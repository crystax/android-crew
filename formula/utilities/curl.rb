class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: { linux_x86_64:   '50ad28bd5e142082e9549a022ff0623ea9ba8bfa2c6b96672adfb8cf4c49ac56',
                                                           linux_x86:      '8a72143b6a1cbb737bbc39c146e86dcf9edc0b38375ae9d6c9ae2938e366a41f',
                                                           darwin_x86_64:  'fef452e8a16f0a3fda790e0c91761355fced1d09fb37c20733657770f7c564b8',
                                                           darwin_x86:     'a8373783ec4ed6594148df195500abe55ec836dbdf032598f968e8e963a2c9e9',
                                                           windows_x86_64: 'f31ecf27a936134d3d74e38abb24318ad738c9ce7f4fba46ea5b209da949384c',
                                                           windows:        '198d98739fb7aeb3760b30075e7e20d2ecea98a8e1ad1794aef39769d45a39ac'
                                                         }

  programs 'curl'
end
