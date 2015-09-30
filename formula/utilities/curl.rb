class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: '2b7ea356a6bd8aa54bed040382b1e47997611d1f02226d45b46c267fb02a07f5'

  programs 'curl'
end
