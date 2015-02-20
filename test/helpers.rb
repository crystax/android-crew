require 'pathname'
require 'open3'
require_relative '../library/global.rb'

module Spec

  module Helpers

    attr_reader :out, :err, :exitstatus

    def crew(*params)
      crewbin = Pathname.new(File.dirname(__FILE__)).parent.join('crew')
      cmd = "#{crewbin} #{params.join(' ')}"
      run_command(cmd)
    end

    def run_command(cmd)
      @out = ""
      @err = ""
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

    def clean_hold
      run_cmd "rm -rf #{Global::HOLD_DIR}/*"
    end

    def clean_formulary
      run_cmd "rm -rf #{Global::FORMULA_DIR}/*"
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

    def run_cmd(cmd)
      `#{cmd}`
      raise "command failed: #{cmd}" if $? != 0
    end
  end
end
