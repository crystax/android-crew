class Ruby < Utility

  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  release version: '2.2.2', crystax_version: 1, sha256: { linux_x86_64:   'c0711f5ac4da0e037538844ebe0a99e4b25fe85a397f80e40b4508ec0a62fc40',
                                                          linux_x86:      '47712566f1315362b723db88a945c857d916259b1d087275e4becb0438ff2c04',
                                                          darwin_x86_64:  'd32c2d0b1e4891489a7757405db603f4b8af5d6237241daffd71a2f7d3606557',
                                                          darwin_x86:     '9c7c37ce13b825c11f60d45103cb55c8c2ee38557aa86e11aa1e507c49fae8bf',
                                                          windows_x86_64: 'f88bf66e12d18dcaa9656dbb73c4064536240fd2ad204d9f0066a95870e52b3d',
                                                          windows:        'a30b509dfe6d916c81ef614144257bf605eac1f3f49b1cf37057cf26eb79529f'
                                                        }

  programs 'ruby', 'rspec'
end
