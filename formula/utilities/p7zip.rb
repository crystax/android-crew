class P7zip < Utility

  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"

  release version: '9.20.1', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                           linux_x86:      '0',
                                                           darwin_x86_64:  '78b3fc64ae6f527f032cddde05f5eedc28eb09f2ae61a4ec096cd38dc877a886',
                                                           darwin_x86:     'ad2969baa4953d0e8811b6631acd21a4006a4bc8f1d256fdf62bde27756c5b96',
                                                           windows_x86_64: '0',
                                                           windows:        '0'
                                                         }

  programs '7za'
end
