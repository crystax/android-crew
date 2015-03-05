require 'pathname'
require 'open3'

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

    def in_cache?(name, version)
      File.exists?(File.join(Global::CACHE_DIR, "#{name}-#{version}.7z"))
    end

    def clean_cache
      FileUtils.remove_dir(Global::CACHE_DIR, true)
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
        run_cmd "cp ./data/#{n} #{Global::FORMULA_DIR}/"
      end
    end

    def install_release(name, version)
      dir = "#{Global::HOLD_DIR}/#{name}/#{version}"
      run_cmd "mkdir -p #{dir}"
      run_cmd "mkdir -p #{dir}/include"
      run_cmd "mkdir -p #{dir}/libs"
      run_cmd "touch #{dir}/Android.mk"
    end

    def repository_init
      clean_hold
      dir = origin_dir
      FileUtils.remove_dir(dir, true)
      FileUtils.mkdir(dir) unless Dir.exists?(dir)
      FileUtils.cd(dir) do
        # todo: use git included with NDK
        run_cmd "git init"
        run_cmd "mkdir cache"
        run_cmd "mkdir formula"
        run_cmd "touch cache/.placeholder"
        run_cmd "touch formula/.placeholder"
        run_cmd "git add cache formula"
        run_cmd "git commit -m initial"
      end
    end

    def repository_clone
      FileUtils.remove_dir(Global::BASE_DIR)
      run_cmd "git clone -q #{origin_dir} #{Global::BASE_DIR}"
    end

    def repository_add_formula(*names)
      dir = origin_dir
      names.each do |n|
        a = n.split(':')
        if 1.size == 1
          dst = src = a[0]
        else
          src = a[0]
          dst = a[1]
        end
        run_cmd "cp ./data/#{src} #{dir}/formula/#{dst}"
      end
      FileUtils.cd(dir) do
        run_cmd "git add ."
        run_cmd "git commit -q -m add_#{names.join('_')}"
      end
    end

    def repository_del_formula(*names)
      dir = origin_dir
      names.each do |n|
        run_cmd "rm #{dir}/formula/#{n}"
      end
      FileUtils.cd(dir) do
        run_cmd "git add ."
        run_cmd "git commit -q -m del_#{names.join('_')}"
      end
    end

    def origin_dir
      Global::BASE_DIR + '.git'
    end

    def run_cmd(cmd)
      `#{cmd}`
      raise "command failed: #{cmd}" if $? != 0
    end
  end
end
