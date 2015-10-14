require 'pathname'
require 'open3'
require 'socket'
require 'rugged'
require 'digest'
require_relative '../library/release.rb'

module Spec

  module Helpers

    class CrewFailed < RuntimeError
      def initialize(cmd, exitcode, err)
        @cmd = cmd
        @exitcode = exitcode
        @err = err
      end

      def to_s
        "failed crew command: #{@cmd}\n"
        "  exit code: #{@exitcode}\n"
        "  error output: #{@err}\n"
      end
    end


    class Repository
      def self.init_at(dir)
        repo = Rugged::Repository.init_at dir
        repo.config['user.email'] = 'crew-test@crystax.net'
        repo.config['user.name'] = 'Crew Test'
        Repository.new dir
      end

      def initialize(dir)
        @repo = Rugged::Repository.new dir
        @repo.checkout 'refs/heads/master' unless @repo.head_unborn?
        @index = @repo.index
      end

      def add(file)
        @index.add path: file,
                   oid: (Rugged::Blob.from_workdir @repo, file),
                   mode: 0100644
      end

      def remove(file)
        @index.remove file
      end

      def commit(message)
        commit = @index.write_tree @repo
        @index.write
        Rugged::Commit.create @repo,
                              message: message,
                              parents: @repo.head_unborn? ? [] : [@repo.head.target],
                              tree: commit,
                              update_ref: 'HEAD'
      end
    end

    attr_reader :command, :out, :err, :exitstatus

    def crew(*params)
      crewbin = Pathname.new(File.dirname(__FILE__)).parent.join('crew')
      run_command("#{crewbin} #{params.join(' ')}")
    end

    def crew_checked(*params)
      crew(*params)
      raise CrewFailed.new(command, exitstatus, err) if exitstatus != 0 or err != ''
    end

    def run_command(cmd)
      @command = cmd
      @out = ''
      @err = ''
      @exitstatus = nil

      Open3.popen3(cmd) do |_, stdout, stderr, waitthr|
        ot = Thread.start do
          while c = stdout.getc
            @out += "#{c}"
          end
        end

        et = Thread.start do
          while c = stderr.getc
            @err += "#{c}"
          end
        end

        ot.join
        et.join

        @exitstatus = waitthr && waitthr.value.exitstatus
      end
    end

    def result
      (exitstatus == 0 and err == '') ? :ok : [exitstatus, err]
    end

    def archive_name(type, name, version, cxver)
      suffix = case type
               when :library
                 ''
               when :utility
                 "-#{Global::PLATFORM}"
               else
                 raise "bad archive type #{type}"
               end
      "#{name}-#{version}_#{cxver}#{suffix}.7z"
    end

    def in_cache?(type, name, version, cxver)
      File.exists?(File.join(Global::CACHE_DIR, archive_name(type, name, version, cxver)))
    end

    def cache_empty?
      Dir[File.join(Global::CACHE_DIR, '*')].empty?
    end

    def clean_cache
      FileUtils.remove_dir(Global::CACHE_DIR)
      FileUtils.mkdir_p(Global::CACHE_DIR)
    end

    def clean_hold
      FileUtils.remove_dir(Global::HOLD_DIR, true)
      FileUtils.mkdir_p(Global::HOLD_DIR)
    end

    def clean_engine
      orig_engine_dir = "#{Crew_test::NDK_COPY_DIR}/prebuilt/#{Global::PLATFORM}/crew"
      engine_dir = "#{Crew_test::NDK_DIR}/prebuilt/#{Global::PLATFORM}/crew"
      Crew_test::UTILS.each do |util|
        version = Global.active_util_version(util, orig_engine_dir)
        File.open(Global.active_file_path(util, engine_dir), 'w') { |f| f.puts version }
        FileUtils.cd("#{engine_dir}/#{util}") do
          dirs = Dir['*'].select { |d| File.directory?(d) }
          d = dirs.pop
          dirs.each { |d| FileUtils.rm_rf d }
          FileUtils.mv(d, version) unless d == version
        end
      end
    end

    def copy_formulas(*names)
      names.each do |n|
        FileUtils.cp File.join('data', n), Global::FORMULA_DIR
      end
    end

    def ndk_init
      FileUtils.rm_rf Crew_test::NDK_DIR
      FileUtils.cp_r Crew_test::NDK_COPY_DIR, Crew_test::NDK_DIR
    end

    def repository_init
      dir = origin_dir
      utils_dir = File.join(dir, 'formula', 'utilities')
      FileUtils.rm_rf dir
      FileUtils.mkdir_p [File.join(dir, 'cache'), utils_dir]
      copy_utilities utils_dir
      FileUtils.cd(dir) do
        repo = Repository.init_at '.'
        [File.join('cache', '.placeholder'), File.join('formula', '.placeholder')].each do |file|
          FileUtils.touch file
          repo.add file
        end
        Dir[File.join('formula', 'utilities', '*')].each { |file| repo.add file }
        repo.commit 'initial'
      end
    end

    def repository_clone
      FileUtils.remove_dir Global::BASE_DIR
      Rugged::Repository.clone_at origin_dir, Global::BASE_DIR
    end

    def repository_network_clone
      FileUtils.remove_dir Global::BASE_DIR
      repo = Rugged::Repository.clone_at 'https://github.com/crystaxnet/crew-test.git', Global::BASE_DIR
      repo.close
    end

    def repository_add_formula(type, *names)
      case type
      when :library
        dir = 'formula'
      when :utility
        dir = File.join('formula', 'utilities')
      else
        raise "unknown formula type: #{type}"
      end
      repo = Repository.new origin_dir
      names.each do |n|
        a = n.split(':')
        if a.size == 1
          dst = src = a[0]
        else
          src = a[0]
          dst = a[1]
        end
        file = File.join(dir, dst)
        FileUtils.cp File.join('data', src), File.join(origin_dir, file)
        repo.add file
      end
      repo.commit "add_#{names.join('_')}"
    end

    def repository_del_formula(*names)
      repo = Repository.new origin_dir
      names.each { |n| repo.remove File.join('formula', n) }
      repo.commit "del_#{names.join('_')}"
    end

    private

    def origin_dir
      Global::BASE_DIR + '.git'
    end

    def copy_utilities(dst = Global::UTILITIES_DIR)
      Crew_test::UTILS.each { |u| FileUtils.cp File.join('data', "#{u}-1.rb"), File.join(dst,  "#{u}.rb") }
    end
  end
end
