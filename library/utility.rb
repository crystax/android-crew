module Utility

  def release_directory(release)
    File.join(Global::ENGINE_DIR, name, "#{release[:version]}_#{release[:crystax_version]}")
  end

  def download_base
    "#{Global::DOWNLOAD_BASE}/utilities"
  end

  def type
    :utility
  end

  def src_dir(release, dirname)
    File.join('..', 'crew', name, release_directory(release), dirname)
  end

  def dest_dir(ndk_dir, platform, dirname)
    File.join(ndk_dir, 'prebuilt', platform, dirname)
  end

  def exec_name(platform, prog)
    prog += '.exe' if platform =~ /windows/
    prog
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
