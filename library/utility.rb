module Utility

  def install_dir
    Global::ENGINE_DIR
  end

  def release_directory(release)
    File.join(install_dir, name, "#{release[:version]}_#{release[:crystax_version]}")
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
end
