class P7zip < Utility

  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"

  release version: '9.20.1', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                           linux_x86:      '0',
                                                           darwin_x86_64:  '0',
                                                           darwin_x86:     '0',
                                                           windows_x86_64: '0',
                                                           windows:        '0'
                                                         }

  programs '7za'
end
