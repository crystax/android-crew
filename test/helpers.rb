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

    def clean
      clean_cache
      clean_hold
      FileUtils.remove_dir(Global::FORMULA_DIR, true)
      FileUtils.mkdir_p(Global::UTILITIES_DIR)
    end

    def copy_formulas(*names)
      names.each do |n|
        FileUtils.cp File.join('data', n), Global::FORMULA_DIR
      end
    end

    def copy_utilities(dst = Global::UTILITIES_DIR)
      Crew_test::UTILS.each { |u| FileUtils.cp File.join('data', "#{u}-1.rb"), File.join(dst,  "#{u}.rb") }
    end

    def install_release(name, version)
      dir = File.join(Global::HOLD_DIR, name, version)
      FileUtils.mkdir_p dir
      FileUtils.mkdir_p File.join(dir, 'include')
      FileUtils.mkdir_p File.join(dir, 'libs')
      FileUtils.touch File.join(dir, 'Android.mk')
    end

    def ndk_init
      FileUtils.rm_rf Crew_test::NDK_DIR
      FileUtils.cp_r Crew_test::NDK_COPY_DIR, Crew_test::NDK_DIR
    end

    def repository_init
      clean_hold
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

    def origin_dir
      Global::BASE_DIR + '.git'
    end

    def utility_working(name)
      util = File.join(Global::TOOLS_DIR, 'bin', name)
      run_command("#{util} -h")
      (exitstatus == 0) and (err == '') ? :ok : "failed: code: #{exitstatus}; error: #{err}"
    end

    def utility_link(prog, util, release)
      link_file = File.join(Global::TOOLS_DIR, 'bin', prog)
      orig_file = File.join(Global::TOOLS_DIR, 'crew', util, release.to_s, 'bin', prog)
      if File.exists? "#{orig_file}.exe"
        link_file += '.exe'
        orig_file += '.exe'
      end
      s1 = Digest::SHA256.hexdigest(File.read(link_file, mode: "rb"))
      s2 = Digest::SHA256.hexdigest(File.read(orig_file, mode: "rb"))
      s1 == s2 ? :ok : "files differ: #{link_file} and #{orig_file}"
    end
  end
end
