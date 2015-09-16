module Crew_test

  UTILS         = ['curl', 'p7zip', 'ruby']
  PORT          = 9999
  DOWNLOAD_BASE = "http://localhost:#{PORT}"
  DATA_DIR      = 'data'
  WWW_DIR       = 'www'
  DOCROOT_DIR   = File.join(WWW_DIR, 'docroot')

end
