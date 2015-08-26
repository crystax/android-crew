class P7zip < Formula
  include Utility

  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"

  release version: '9.20.1', crystax_version: 1, sha256: '0'

  def link(ndk_dir, platform, release)
    FileUtils.cd(dest_dir(ndk_dir, platform, 'bin')) do
      prog_7za = exec_name(platform, '7za')
      FileUtils.rm_rf prog_7za
      FileUtils.ln_s File.join(src_dir(release, 'bin'), prog_7za), prog_7za
    end
  end
end
