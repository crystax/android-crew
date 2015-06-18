require 'pathname'
require 'open3'
require 'socket'
require 'rugged'

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

    def archive_name(name, version)
      "#{name}-#{version}.7z"
    end

    def in_cache?(name, version)
      File.exists?(File.join(Global::CACHE_DIR, archive_name(name, version)))
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
      FileUtils.mkdir_p(Global::FORMULA_DIR)
    end

    def copy_formulas(*names)
      names.each do |n|
        FileUtils.cp File.join('data', n), Global::FORMULA_DIR
      end
    end

    def install_release(name, version)
      dir = File.join(Global::HOLD_DIR, name, version)
      FileUtils.mkdir_p dir
      FileUtils.mkdir_p File.join(dir, 'include')
      FileUtils.mkdir_p File.join(dir, 'libs')
      FileUtils.touch File.join(dir, 'Android.mk')
    end

    def repository_init
      clean_hold
      dir = origin_dir
      FileUtils.rm_rf dir
      FileUtils.mkdir dir
      FileUtils.cd(dir) do
        repo = Repository.init_at '.'
        FileUtils.mkdir [File.join('cache'), File.join('formula')]
        [File.join('cache', '.placeholder'), File.join('formula', '.placeholder')].each do |file|
          FileUtils.touch file
          repo.add file
        end
        repo.commit 'initial'
      end
    end

    def repository_clone
      FileUtils.remove_dir(Global::BASE_DIR)
      Rugged::Repository.clone_at origin_dir, Global::BASE_DIR
    end

    def repository_network_clone
      FileUtils.remove_dir(Global::BASE_DIR)
      Rugged::Repository.clone_at 'https://github.com/crystaxnet/crew-test.git', Global::BASE_DIR
    end

    def repository_add_formula(*names)
      repo = Repository.new origin_dir
      names.each do |n|
        a = n.split(':')
        if a.size == 1
          dst = src = a[0]
        else
          src = a[0]
          dst = a[1]
        end
        file = File.join('formula', dst)
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

    def add_garbage_into_hold name
      FileUtils.cp File.join('data', 'garbage'),  File.join(Global::HOLD_DIR, name, 'garbage')
    end

    def origin_dir
      Global::BASE_DIR + '.git'
    end
  end
end
