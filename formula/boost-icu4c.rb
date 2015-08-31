class BoostIcu4c < Formula
  include Library

  desc 'Boost libraries built with ICU4C'
  homepage 'http://www.boost.org'
  name 'boost+icu4c'

  release version: '1.57.0', crystax_version: 1, sha256: '6669dc32da5b73471cd98023d06d7ac6ccfb3cdeeaa2607de91ac7da848dcfd0'
  release version: '1.58.0', crystax_version: 1, sha256: '1eccb7b625b412f5dedf3cbe5386a760664fad212e325de029f920e7bdfd7aa3'
  release version: '1.59.0', crystax_version: 1, sha256: 'fdfd64eddc11035bde49e477f39f7c2419ed7bd5ee2ef88245c4013be0db8168'

  depends_on 'icu4c'
end
