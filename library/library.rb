module Library

  def install_dir
    Global::HOLD_DIR
  end

  def release_directory(release)
    File.join(install_dir, name, release[:version])
  end

  def download_base
    "#{Global::DOWNLOAD_BASE}/packages"
  end

  def type
    :library
  end
end
