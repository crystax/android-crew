module Crew_test

  UTILS           = ['curl', 'libarchive', 'ruby', 'xz']
  PORT            = 9999
  DOWNLOAD_BASE   = "http://localhost:#{PORT}"
  DATA_DIR        = 'data'
  CREW_DIR        = 'crew'
  NDK_DIR         = 'ndk'
  NDK_COPY_DIR    = 'ndk.copy'
  WWW_DIR         = 'www'
  DOCROOT_DIR     = File.join(WWW_DIR, 'docroot')
  DATA_READY_FILE = '.testdataprepared'

end
