module Utility

  def type
    :utility
  end

  def src_dir(release, dirname)
    File.join('..', 'crew', name, Formula.package_version(release), dirname)
  end

  def dest_dir(ndk_dir, platform, dirname)
    File.join(ndk_dir, 'prebuilt', platform, dirname)
  end

  def exec_name(platform, prog)
    prog += '.exe' if platform =~ /windows/
    prog
  end
end
