class Xz < Utility

  desc "General-purpose data compression with high compression ratio"
  homepage "http://tukaani.org/xz/"

  release version: '5.2.2', crystax_version: 1, sha256: { linux_x86_64:   '0',
                                                          linux_x86:      '0',
                                                          darwin_x86_64:  'd3127996fe3e5a55b297692667430e65046a928a9cb6bdcf0e9e90a7aeafffbf',
                                                          darwin_x86:     'cede694c6d37788e799c819e5418b0d53fe82f0dcf378cf0a990f1cf29654482',
                                                          windows_x86_64: '0',
                                                          windows:        '0'
                                                         }

  programs 'xz'
end
