module Crew_test

  UTILS         = ['curl', 'p7zip', 'ruby']
  PORT          = 9999
  DOWNLOAD_BASE = "http://localhost:#{PORT}"
  DATA_DIR      = 'data'
  NDK_DIR       = 'ndk'
  WWW_DIR       = 'www'
  DOCROOT_DIR   = File.join(WWW_DIR, 'docroot')

end
