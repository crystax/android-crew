require 'open3'
require_relative 'global.rb'
require_relative 'exceptions.rb'


def args_to_cmd_s(args)
  args.map { |a| a.to_s.gsub " ", "\\ " }.join(" ")
end


def curl(*args)
  curl = Pathname.new Global::CREW_CURL_PROG
  raise "#{curl} is not executable" unless curl.exist? and curl.executable?

  args = ['-f#LA', Global::USER_AGENT, *args]
  # See https://github.com/Homebrew/homebrew/issues/6103
  # todo: MacOS or not MacOS?
  #args << "--insecure" if MacOS.version < "10.6"
  args << "--verbose" if Global::CREW_DEBUG.include?(:curl)
  args << "--silent" unless $stdout.tty?

  cmd = "#{curl} #{args_to_cmd_s(args)}"
  debug("cmd: #{cmd}")

  Open3.popen3(cmd) do |_, out, err, t|
    ot = Thread.start do
      while c = out.getc
        $stdout.putc c
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
end

def unpack_archive(path, outdir)

  _7z = Global::CREW_7Z_PROG
  flags = "x -y -o#{outdir}"

  cmd = "#{_7z} #{flags} #{path}"
  debug("cmd: #{cmd}")

  Open3.popen3(cmd) do |_, out, err, t|
    ot = Thread.start do
      while c = out.getc
        if Global::CREW_DEBUG.include?(:_7z)
          $stdout.putc c
        end
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

    debug("t.value: #{t.value}")
    debug("errstr:  #{errstr}")
    raise ErrorDuringExecution.new(cmd, errstr) unless t.value.success?
  end

end
