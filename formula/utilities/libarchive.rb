class Libarchive < Utility

  desc "Multi-format archive and compression library, bsdtar utility"
  homepage "http://www.libarchive.org"

  release version: '3.1.2', crystax_version: 1, sha256: { linux_x86_64:   '368ce14585e58e7dc59ddad202c7b486dfa9c44d1e6968aeef7232e84df5711d',
                                                          linux_x86:      'ea3b9bf7413d0f7e76dae28ac21368cf2f45852dfb7863668a2bc029b31aa090',
                                                          darwin_x86_64:  '40a813a55488f72f0fe0f8504647d34f3c5fc15b033bccb25c30e935b6175f92',
                                                          darwin_x86:     'dd5ab912fa596ccb774fe4dca464bce13b782b7aa2a7708c8311636410a89788',
                                                          windows_x86_64: '1976ac93938c11a9d0c2ed1dab163218085b4e74c30b27bde84ae583b76c9944',
                                                          windows:        'f3f715d10572f620152810855a8356dbbce75937d3639854ca9c60a0b07396b8'
                                                         }

  programs 'bsdtar'
end
