class Curl < Formula
  include Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: '0'

  def link(ndk_dir, platform, ver, cxver)
    FileUtils.cd(dest_dir(ndk_dir, platform, 'bin')) do
      prog_curl = exec_name(platform, 'curl')
      FileUtils.rm_rf prog_curl
      FileUtils.ln_s File.join(src_dir(ver, cxver, 'bin'), prog_curl), prog_curl
    end
  end
end
