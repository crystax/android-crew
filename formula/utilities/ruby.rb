class Ruby < Utility

  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  release version: '2.2.2', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                          linux_x86:      '0',
                                                          darwin_x86_64:  'e0473a406f7add9f5922bbb5ee467528b5b4e75df96b39b67f828b604f15b51b',
                                                          darwin_x86:     '974518c370cc0f1d951921b5172d3a494368f228051f0ef3338db41cefe93e3d',
                                                          windows_x86_64: '0',
                                                          windows:        '0'
                                                        }

  programs 'ruby', 'rspec'
end
