class Libtwo < Library

  desc "Library Two"
  homepage "http://www.libtwo.org"

  release version: '1.1.0', crystax_version: 1, sha256: '5bf047f31f2ac9c5768e2db82b11d04b6fe6de2ed1f28c2eb153c2e587d75c17'
  release version: '2.2.0', crystax_version: 1, sha256: '5bf047f31f2ac9c5768e2db82b11d04b6fe6de2ed1f28c2eb153c2e587d75c17'

  depends_on 'libone'
end
