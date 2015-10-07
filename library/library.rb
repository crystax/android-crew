require_relative 'formula.rb'
require_relative 'release.rb'


class Library < Formula

  def release_directory(release)
    File.join(Global::HOLD_DIR, name, release.version)
  end

  def download_base
    "#{Global::DOWNLOAD_BASE}/packages"
  end

  def type
    :library
  end

  private

  def archive_filename(release)
    "#{name}-#{Formula.package_version(release)}.7z"
  end

  def sha256_sum(release)
    release.shasum(:android)
  end

  def install_archive(outdir, archive)
    FileUtils.rm_rf outdir
    FileUtils.mkdir_p outdir
    Utils.unpack(archive, outdir)
  end
end
