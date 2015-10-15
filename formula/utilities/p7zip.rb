class P7zip < Utility

  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"

  release version: '9.20.1', crystax_version: 1, sha256: { linux_x86_64:   '60269cd57ebed41eb804f4c50abc9b3591dc12b62fbcf6d5b6f0ef89a71d9bd6',
                                                           linux_x86:      '05a5eef9b8816649712b7514318fb6987460073607614b9840da1eca43c477e9',
                                                           darwin_x86_64:  '2eb2d00814a6ce4a2de1e0c2ff7fe10b106a08e3c21bab62a41c8d754056a02a',
                                                           darwin_x86:     '8ae5753ea099c6eebeb5049f4465d613f8c41c50084c54561479b8c6442ab9b5',
                                                           windows_x86_64: '536712e0607617bc78927dcc430b2d5fb98d8801f024e76400034068b4bfad2e',
                                                           windows:        '941c9f3ecb2a1d3a85aafd1bf2a486fb99efdd90a654d7d773d22f890439e148'
                                                         }

  programs '7za'
end
