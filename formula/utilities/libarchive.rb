class Libarchive < Utility

  desc "Multi-format archive and compression library, bsdtar utility"
  homepage "http://www.libarchive.org"

  release version: '3.1.2', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                          linux_x86:      '0',
                                                          darwin_x86_64:  '40a813a55488f72f0fe0f8504647d34f3c5fc15b033bccb25c30e935b6175f92',
                                                          darwin_x86:     'dd5ab912fa596ccb774fe4dca464bce13b782b7aa2a7708c8311636410a89788',
                                                          windows_x86_64: '0',
                                                          windows:        '0'
                                                         }

  programs 'bsdtar'
end
