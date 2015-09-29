class Curl < Utility

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "http://curl.haxx.se/"

  release version: '7.42.0', crystax_version: 1, sha256: '19a249e61b433c717b3e496addad5c6d7b69a5ff8429e464fddb4be61257540d'

  programs 'curl'
end
