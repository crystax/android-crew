require 'pathname'
require 'open3'
require 'socket'
require 'rugged'
require 'digest'
require 'find'
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
        repo.close
        Repository.new dir
      end

      def self.clone_at(url, local_path, options = {})
        repo = Rugged::Repository.clone_at(url, local_path, options)
        repo.close
        Repository.new local_path
      end

      def initialize(dir)
        @repo = Rugged::Repository.new dir
        @repo.checkout 'refs/heads/master' unless @repo.head_unborn?
      end

      def remotes
        @repo.remotes
      end

      def add(file)
        @repo.index.add file
        # @repo.index.add path: file,
        #                 oid: Rugged::Blob.from_workdir(@repo, file),
        #                 mode: 0100644
      end

      def remove(file)
        @repo.index.remove file
      end

      def commit(message)
        commit = @repo.index.write_tree @repo
        @repo.index.write
        Rugged::Commit.create @repo,
                              message: message,
                              parents: @repo.head_unborn? ? [] : [@repo.head.target],
                              tree: commit,
                              update_ref: 'HEAD'
      end

      def push(options)
        @repo.remotes['origin'].push ['refs/heads/master'], options
      end

      def close
        @repo.close
        @repo = nil
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
      "#{name}-#{version}_#{cxver}#{suffix}.#{Global::ARCH_EXT}"
    end

    def in_cache?(type, name, version, cxver)
      File.exists?(File.join(Global::CACHE_DIR, archive_name(type, name, version, cxver)))
    end

    def cache_empty?
      Dir[File.join(Global::CACHE_DIR, '*')].empty?
    end

    def clean_cache
      FileUtils.rm_rf   Global::CACHE_DIR
      FileUtils.mkdir_p Global::CACHE_DIR
    end

    def clean_hold
      FileUtils.rm_rf   Global::HOLD_DIR
      FileUtils.mkdir_p Global::HOLD_DIR
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
      FileUtils.rm_rf origin_dir
      repo = Repository.init_at origin_dir
      repository_add_initial_files origin_dir, repo
      repo.close
    end

    def repository_clone
      FileUtils.rm_rf Global::BASE_DIR
      Repository.clone_at(origin_dir, Global::BASE_DIR).close
    end

    TEST_REPO_GIT_URL   = 'git@github.com:crystaxnet/crew-test.git'
    TEST_REPO_HTTPS_URL = 'https://github.com/crystaxnet/crew-test.git'

    def repository_network_init
      # clone network repository, clean it and push back
      FileUtils.rm_rf net_origin_dir
      repo = Repository.clone_at(TEST_REPO_GIT_URL, net_origin_dir, credentials: ssl_key)
      Find.find("#{net_origin_dir}/cache", "#{net_origin_dir}/formula") do |f|
        if File.file?(f)
          File.unlink f
          repo.remove(f.gsub("#{net_origin_dir}/", ''))
        end
      end
      repo.commit "clean repository"
      repo.push credentials: ssl_key
      # add new files to the repository and push changes
      repository_add_initial_files net_origin_dir, repo
      repo.push credentials: ssl_key
      repo.close
    end

    def repository_network_clone
      FileUtils.rm_rf Global::BASE_DIR
      Repository.clone_at(TEST_REPO_HTTPS_URL, Global::BASE_DIR).close
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

    def net_origin_dir
      Global::BASE_DIR + '.net'
    end

    def ssl_key
      Rugged::Credentials::SshKey.new(username:   'git',
                                      publickey:  File.expand_path("~/.ssh/id_rsa.pub"),
                                      privatekey: File.expand_path("~/.ssh/id_rsa"))
    end

    def repository_add_initial_files(dir, repo)
      utils_dir = File.join(dir, 'formula', 'utilities')
      FileUtils.mkdir_p [File.join(dir, 'cache'), utils_dir]
      Crew_test::UTILS.each { |u| FileUtils.cp File.join('data', "#{u}-1.rb"), File.join(utils_dir,  "#{u}.rb") }
      FileUtils.cd(dir) do
        [File.join('cache', '.placeholder'), File.join('formula', '.placeholder')].each do |file|
          FileUtils.touch file
          repo.add file
        end
        Dir[File.join('formula', 'utilities', '*')].each { |file| repo.add file }
        repo.commit 'add initial files'
      end
    end
  end
end
