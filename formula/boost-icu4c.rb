class BoostIcu4c < Library

  desc 'Boost libraries built with ICU4C'
  homepage 'http://www.boost.org'
  name 'boost+icu4c'

  release version: '1.57.0', crystax_version: 1, sha256: '42c1c8ab00f17ad2dd927cc8a2c8dac8ac2791264f674b121b3bcbdf0d2011dd'
  release version: '1.58.0', crystax_version: 1, sha256: 'efa668966560eec18e15eeecd6e9c1d53077d378397fc27b3de38e58e72b1696'
  release version: '1.59.0', crystax_version: 1, sha256: '3dcf79d9f0c92340b4a6e8f2eadb3099e27f0b5f60ae9e06f57583a12702ae79'

  depends_on 'icu4c'
end
