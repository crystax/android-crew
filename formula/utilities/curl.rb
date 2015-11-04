class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: { linux_x86_64:   '6e710f2be60c42c10180593da0b42ac09b9464ee2198fbab43b137a8c4045a1e',
                                                           linux_x86:      '96ed104136be6b7a3be2ce635b089ff72880100fae65f6038edd9adfd23e77a9',
                                                           darwin_x86_64:  '647c54063281bf3b5b86e17410a3c4a78677cb8f53fd506e403136524194baa3',
                                                           darwin_x86:     'b1e9fe253dab50c0ab250042cc2b9ca10fb9d225f588c437ddb0443b3467a865',
                                                           windows_x86_64: '8c00a102c8d7b4c9bd53f8571d34bd167e020431d32e04bd466515c9c4adf0ca',
                                                           windows:        '93054cfcdd952b8c4b3337fab791cf88728a892f4d4d4040d4bffe6c14f4c0a1'
                                                         }
end
