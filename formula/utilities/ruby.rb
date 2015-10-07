class Ruby < Utility

  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  release version: '2.2.2', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                          linux_x86:      '0',
                                                          darwin_x86_64:  '0',
                                                          darwin_x86:     '0',
                                                          windows_x86_64: '0',
                                                          windows:        '0'
                                                        }

  programs 'ruby', 'rspec'
end
