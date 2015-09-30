class P7zip < Utility

  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"

  release version: '9.20.1', crystax_version: 1, sha256: 'ab17848c7ef840dbfdc1663eb4f0f4f3f3d6fdb752c596f72c8226776922b08f'

  programs '7za'
end
