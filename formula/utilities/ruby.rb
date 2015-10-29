class Ruby < Utility

  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  release version: '2.2.2', crystax_version: 1, sha256: { linux_x86_64:   'aebd0395d26d44a2668cc47d1742f438469bd8e8095034fd52978b1d96b4ef9a',
                                                          linux_x86:      '3bf1ab677198f4b952c18dd8342e1c23c1cd5874b1d8137786caf650bce96612',
                                                          darwin_x86_64:  'b3e3855a156abee74def92f4eeda5de6410681873f7bfbc400f312f9c0157b51',
                                                          darwin_x86:     '67f8de477119a1d6dea02453e71f77768e2838d370490a407c367e98857bd6e3',
                                                          windows_x86_64: 'd2dd7388498b4bb604742e105aad1d39e7101c0b2ba24721fe4374209d07f827',
                                                          windows:        'ca922e67a3bab82d4eeb11a7818d4b0714000922d1f4cbf586717edbd9b0a1f4'
                                                        }

  programs 'ruby', 'rspec'
end
