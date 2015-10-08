class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                           linux_x86:      '0',
                                                           darwin_x86_64:  '5e34409b794bb24c8bc07c25a0d252531e66204a0d5b5f6072fd87e9e5078119',
                                                           darwin_x86:     '5447930752a64791800bac0b5a6d1b4cdf094ee1eff85e7b67820fb4c48923b6',
                                                           windows_x86_64: '0',
                                                           windows:        '0'
                                                         }

  programs 'curl'
end
