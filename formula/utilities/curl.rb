class Curl < Formula
  include Utility

  homepage "http://curl.haxx.se/"

  release version: '7.42.0', build_number: 1, sha256: '0'

  def link(ndk_dir, platform, ver, bldnum)
    FileUtils.cd(dest_bin_dir(ndk_dir, platform)) do
      prog_curl = exec_name(platform, 'curl')
      FileUtils.rm_rf prog_curl
      FileUtils.ln_s File.join(src_bin_dir(ver, bldnum), prog_curl), prog_curl
    end
  end
end
