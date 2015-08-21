module Utility

  def type
    :utility
  end

  def src_dir(ver, cxver, dirname)
    File.join('..', 'crew', name, Formula.package_version(ver, cxver), dirname)
  end

  def dest_dir(ndk_dir, platform, dirname)
    File.join(ndk_dir, 'prebuilt', platform, dirname)
  end

  def exec_name(platform, prog)
    prog += '.exe' if platform =~ /windows/
    prog
  end
end
