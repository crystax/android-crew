class Ruby < Utility

  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  release version: '2.2.2', crystax_version: 1, sha256: { linux_x86_64:   'aebd0395d26d44a2668cc47d1742f438469bd8e8095034fd52978b1d96b4ef9a',
                                                          linux_x86:      '3bf1ab677198f4b952c18dd8342e1c23c1cd5874b1d8137786caf650bce96612',
                                                          darwin_x86_64:  'd32c2d0b1e4891489a7757405db603f4b8af5d6237241daffd71a2f7d3606557',
                                                          darwin_x86:     '9c7c37ce13b825c11f60d45103cb55c8c2ee38557aa86e11aa1e507c49fae8bf',
                                                          windows_x86_64: 'd2dd7388498b4bb604742e105aad1d39e7101c0b2ba24721fe4374209d07f827',
                                                          windows:        'ca922e67a3bab82d4eeb11a7818d4b0714000922d1f4cbf586717edbd9b0a1f4'
                                                        }

  programs 'ruby', 'rspec'
end
