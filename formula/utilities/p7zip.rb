class P7zip < Utility

  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"

  release version: '9.20.1', crystax_version: 1, sha256: { linux_x86_64:   '5326ca3c15ea6aef452176042495a393d55eb04cd5910fc1e10bb0ff3e319461',
                                                           linux_x86:      'f89bbd94e262417ed7971ef9a48da5967d45b3033b3be8a7ae568583d551d820',
                                                           darwin_x86_64:  '2eb2d00814a6ce4a2de1e0c2ff7fe10b106a08e3c21bab62a41c8d754056a02a',
                                                           darwin_x86:     '8ae5753ea099c6eebeb5049f4465d613f8c41c50084c54561479b8c6442ab9b5',
                                                           windows_x86_64: '6f49fcb4431a1b6d5140b05b9efd3b89dd405ed05dfeb1b094ec18526fd674c5',
                                                           windows:        'df39fb139d3a45c13d17ec70b23f8ee8b5e1bc968dd760c725a51b7637dfb231'
                                                         }

  programs '7za'
end
