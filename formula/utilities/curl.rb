class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                           linux_x86:      '0',
                                                           darwin_x86_64:  '0',
                                                           darwin_x86:     '0',
                                                           windows_x86_64: '0',
                                                           windows:        '0'
                                                         }

  programs 'curl'
end
