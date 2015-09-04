class Libthree < Formula
  include Library

  desc "Library Three"
  homepage "http://www.libthree.org"

  release version: '1.1.1', crystax_version: 1, sha256: '1718131ec3207014ee5a944f476241ff3587309722a2dd65b9ca8376ddd698ea'
  release version: '2.2.2', crystax_version: 1, sha256: '1718131ec3207014ee5a944f476241ff3587309722a2dd65b9ca8376ddd698ea'
  release version: '3.3.3', crystax_version: 1, sha256: '1718131ec3207014ee5a944f476241ff3587309722a2dd65b9ca8376ddd698ea'

  depends_on 'libone'
  depends_on 'libtwo'
end
