require 'open3'
require_relative 'global.rb'
require_relative 'exceptions.rb'

module Utils

  @@crew_curl_prog = nil
  @@crew_7z_prog   = nil


  def self.run_command(prog, *args)
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

      raise ErrorDuringExecution.new(cmd, t.value.exitstatus, errstr) unless t.value.success?
    end

    outstr
  end

  def self.download(url, outpath)
    args = [url, '-o', outpath, '--silent', '--fail']
    run_command(crew_curl_prog, *args)
  rescue ErrorDuringExecution => e
    case e.exit_code
    when 7
      raise DownloadError.new(url, e.exit_code, "failed to connect to host")
    when 22
      raise DownloadError.new(url, e.exit_code, "HTTP page not retrieved")
    else
      raise DownloadError.new(url, e.exit_code)
    end
  end

  def self.unpack(archive, outdir)
    args = ["x", "-y", "-o#{outdir}", archive]
    run_command(crew_7z_prog, *args)
  end

  # private

  def self.crew_curl_prog
    @@crew_curl_prog = Pathname.new(Global.active_util_dir('curl')).realpath  + "curl#{Global::EXE_EXT}" unless @@crew_curl_prog
    @@crew_curl_prog
  end

  def self.crew_7z_prog
    @@crew_7z_prog = Pathname.new(Global.active_util_dir('p7zip')).realpath + "7za#{Global::EXE_EXT}" unless @@crew_7z_prog
    @@crew_7z_prog
  end

  def self.to_cmd_s(*args)
    # todo: escape ( and ) too
    s = args.map { |a| a.to_s.gsub " ", "\\ " }.join(" ")
    s.gsub(%r{/}) { '\\' } if Global::OS == 'windows'
    s
  end
end
