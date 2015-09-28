require_relative 'formula.rb'


class Utility < Formula

  def self.programs(*args)
    if args.size == 0
      @programs ? @programs : []
    else
      @programs = args
    end
  end

  def programs
    self.class.programs
  end

  def release_directory(release)
    File.join(Global::ENGINE_DIR, name, release.to_s)
  end

  def download_base
    "#{Global::DOWNLOAD_BASE}/utilities"
  end

  def type
    :utility
  end

  def link(release = releases.last, tools_dir = Global::TOOLS_DIR)
    bin_dir = File.join(tools_dir, 'bin')
    FileUtils.mkdir_p bin_dir
    FileUtils.cd(bin_dir) do
      src_dir = File.join('..', 'crew', name, release.to_s, 'bin')
      programs.each do |prog|
        prog += '.exe' if File.exists? File.join(src_dir, "#{prog}.exe")
        FileUtils.rm_f prog
        FileUtils.ln_s File.join(src_dir, prog),  prog
      end
    end
  end

  private

  def archive_filename(release)
    "#{name}-#{Formula.package_version(release)}-#{Global::PLATFORM}.7z"
  end

  def install_archive(outdir, archive)
    FileUtils.rm_rf outdir
    FileUtils.mkdir_p outdir
    Utils.unpack(archive, Global::NDK_DIR)
  end
end
