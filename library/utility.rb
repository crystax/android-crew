module Utility

  def src_bin_dir(ver, bldnum)
    File.join('..', 'crew', name, Formula.package_version(ver, bldnum), 'bin')
  end

  def dest_bin_dir(ndk_dir, platform)
    File.join(ndk_dir, 'prebuilt', platform, 'bin')
  end

  def exec_name(platform, prog)
    prog += '.exe' if platform =~ /windows/
    prog
  end
end
