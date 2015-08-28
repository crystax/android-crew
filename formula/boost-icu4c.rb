class BoostIcu4c < Formula
  include Library

  desc 'Boost libraries built with ICU4C'
  homepage 'http://www.boost.org'
  name 'boost+icu4c'

  release version: '1.57.0', crystax_version: 1, sha256: '0'
  release version: '1.58.0', crystax_version: 1, sha256: '0'
  release version: '1.59.0', crystax_version: 1, sha256: '0'

  depends_on 'icu4c'
end
