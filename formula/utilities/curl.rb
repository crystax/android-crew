class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: { linux_x86_64:   '264d6d1109304c65a7592d4026872d3e987505814ffcebe856762bc80614dc5e',
                                                           linux_x86:      'efb2b51788820b27d9cf58c5f54de4b2758ce71eb6dcb62001d019ac13930b71',
                                                           darwin_x86_64:  '647c54063281bf3b5b86e17410a3c4a78677cb8f53fd506e403136524194baa3',
                                                           darwin_x86:     'b1e9fe253dab50c0ab250042cc2b9ca10fb9d225f588c437ddb0443b3467a865',
                                                           windows_x86_64: '0f267afc420bbfbcc986da6d7b10e7026c60bba443458192ae5709c9d58e16fe',
                                                           windows:        '80eebb9b2affc8be8352365656e351681ec5c81c17cd2dc93f96ce02681afce1'
                                                         }

  programs 'curl'
end
