require 'open3'
require_relative 'global.rb'
require_relative 'exceptions.rb'

module Utils

  # todo: add hash with options like this { stdout: drop|string, stdin: ignore }
  def self.run_command(prog, *args)
    #todo: check prog, may be substitute our's version (included with NDK)
    #      for the known prog like git, curl, 7z, etc
    cmd = to_cmd_s(prog, *args)

    outstr = ""
    Open3.popen3(cmd) do |_, out, err, t|
      ot = Thread.start do
        while c = out.getc
          $stdout.putc c if Global::DEBUG.include?(:stdout)
          outstr += "#{c}"
        end
      end

      errstr = ""
      et = Thread.start do
        while c = err.getc
          errstr += "#{c}"
        end
      end

      ot.join
      et.join

      raise ErrorDuringExecution.new(cmd, errstr) unless t.value.success?
    end

    outstr
  end

  def self.download(url, outpath)
    args = ['-f#LA', Global::USER_AGENT, url, "-o", outpath]
    # See https://github.com/Homebrew/homebrew/issues/6103
    # todo: MacOS or not MacOS?
    #args << "--insecure" if MacOS.version < "10.6"
    args << "--verbose" if Global::DEBUG.include?(:curl)
    args << "--silent" unless $stdout.tty?

    run_command(Global::CREW_CURL_PROG, *args)
  end

  def self.unpack(archive, outdir)
    args = ["x", "-y", "-o#{outdir}", archive]
    run_command(Global::CREW_7Z_PROG, *args)
  end

  def self.git(*args)
    run_command(Global::CREW_GIT_PROG, *args)
  end

  private

  def self.to_cmd_s(*args)
    # todo: escape ( and ) too
    args.map { |a| a.to_s.gsub " ", "\\ " }.join(" ")
  end
end
