require 'pathname'
require 'open3'
require 'socket'

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
      FileUtils.remove_dir(dir, true)
      FileUtils.mkdir(dir) unless Dir.exists?(dir)
      FileUtils.cd(dir) do
        git 'init'
        FileUtils.mkdir 'cache'
        FileUtils.mkdir 'formula'
        FileUtils.touch File.join('cache', '.placeholder')
        FileUtils.touch File.join('formula', '.placeholder')
        git 'add cache formula'
        git 'commit -m initial'
      end
    end

    def repository_clone
      FileUtils.remove_dir(Global::BASE_DIR)
      git "clone -q #{origin_dir} #{Global::BASE_DIR}"
    end

    def repository_add_formula(*names)
      dir = origin_dir
      names.each do |n|
        a = n.split(':')
        if a.size == 1
          dst = src = a[0]
        else
          src = a[0]
          dst = a[1]
        end
        FileUtils.cp File.join('data', src), File.join(dir, 'formula', dst)
      end
      FileUtils.cd(dir) do
        git "add ."
        git "commit -q -m add_#{names.join('_')}"
      end
    end

    def repository_del_formula(*names)
      dir = origin_dir
      names.each do |n|
        File.delete File.join(dir, 'formula', n)
      end
      FileUtils.cd(dir) do
        git "add ."
        git "commit -q -m del_#{names.join('_')}"
      end
    end

    def add_garbage_into_hold name
      FileUtils.cp File.join('data', 'garbage'),  File.join(Global::HOLD_DIR, name, 'garbage')
    end

    def origin_dir
      Global::BASE_DIR + '.git'
    end

    def git(args)
      run_command("#{Global::CREW_GIT_PROG} #{args}")
      raise "git command failed: #{cmd}" if exitstatus != 0
    end
  end
end
