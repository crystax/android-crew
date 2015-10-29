class Libthree < Library

  desc "Library Three"
  homepage "http://www.libthree.org"

  release version: '1.1.1', crystax_version: 1, sha256: '5fe3fd6522207af3bd802c3738adb36b47f6a6da13264cf2de610d97826c8f8c'
  release version: '2.2.2', crystax_version: 1, sha256: '5fe3fd6522207af3bd802c3738adb36b47f6a6da13264cf2de610d97826c8f8c'
  release version: '3.3.3', crystax_version: 1, sha256: '5fe3fd6522207af3bd802c3738adb36b47f6a6da13264cf2de610d97826c8f8c'

  depends_on 'libone'
  depends_on 'libtwo'
end
