class Ruby < Utility

  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  release version: '2.2.2', crystax_version: 1, sha256: { linux_x86_64:   'c0711f5ac4da0e037538844ebe0a99e4b25fe85a397f80e40b4508ec0a62fc40',
                                                          linux_x86:      '47712566f1315362b723db88a945c857d916259b1d087275e4becb0438ff2c04',
                                                          darwin_x86_64:  'e0473a406f7add9f5922bbb5ee467528b5b4e75df96b39b67f828b604f15b51b',
                                                          darwin_x86:     '974518c370cc0f1d951921b5172d3a494368f228051f0ef3338db41cefe93e3d',
                                                          windows_x86_64: 'f88bf66e12d18dcaa9656dbb73c4064536240fd2ad204d9f0066a95870e52b3d',
                                                          windows:        'a30b509dfe6d916c81ef614144257bf605eac1f3f49b1cf37057cf26eb79529f'
                                                        }

  programs 'ruby', 'rspec'
end
