require 'open3'

module Utils

  # todo: add hash with options like this { stdout: drop|string, stdin: ignore }
  def self.run_command(prog, *args)
    #todo: check prog, may be substitute our's version (included with NDK)
    #      for the known prog like curl, 7z, etc
    cmd = to_cmd_s(prog, *args)

    outstr = ""
    Open3.popen3(cmd) do |_, out, err, t|
      ot = Thread.start do
        while c = out.getc
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
    args = [url, "-o", outpath, "--silent"]
    run_command(Global::CREW_CURL_PROG, *args)
  end

  def self.unpack(archive, outdir)
    args = ["x", "-y", "-o#{outdir}", archive]
    run_command(Global::CREW_7Z_PROG, *args)
  end

  private

  def self.to_cmd_s(*args)
    # todo: escape ( and ) too
    args.map { |a| a.to_s.gsub " ", "\\ " }.join(" ")
  end
end
