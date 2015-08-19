class P7zip < Formula
  include Utility

  homepage "http://p7zip.sourceforge.net/"

  release version: '9.20.1', build_number: 1, sha256: '0'

  def link(ndk_dir, platform, ver, bldnum)
    FileUtils.cd(dest_dir(ndk_dir, platform, 'bin')) do
      prog_7za = exec_name(platform, '7za')
      FileUtils.rm_rf prog_7za
      FileUtils.ln_s File.join(src_dir(ver, bldnum, 'bin'), prog_7za), prog_7za
    end
  end
end
