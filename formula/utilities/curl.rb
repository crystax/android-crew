class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: { linux_x86_64:   '264d6d1109304c65a7592d4026872d3e987505814ffcebe856762bc80614dc5e',
                                                           linux_x86:      'efb2b51788820b27d9cf58c5f54de4b2758ce71eb6dcb62001d019ac13930b71',
                                                           darwin_x86_64:  'fef452e8a16f0a3fda790e0c91761355fced1d09fb37c20733657770f7c564b8',
                                                           darwin_x86:     'a8373783ec4ed6594148df195500abe55ec836dbdf032598f968e8e963a2c9e9',
                                                           windows_x86_64: '0f267afc420bbfbcc986da6d7b10e7026c60bba443458192ae5709c9d58e16fe',
                                                           windows:        '80eebb9b2affc8be8352365656e351681ec5c81c17cd2dc93f96ce02681afce1'
                                                         }

  programs 'curl'
end
