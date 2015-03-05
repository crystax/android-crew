unit_test_files = test_crew.rb

rspec_files = cmd_nocmd_spec.rb cmd_version_spec.rb cmd_help_spec.rb cmd_list_spec.rb cmd_info_spec.rb \
              cmd_cleanup_spec.rb cmd_install_spec.rb cmd_remove_spec.rb cmd_update_spec.rb            \
              cmd_upgrade_spec.rb


# todo: use ruby, rspec from NDK
RUBY  = ruby
RSPEC = rspec

CREW_BASE_DIR      = crew
CREW_DOWNLOAD_BASE = http://127.0.0.1:9999
CREW_NDK_DIR       = ndk

export CREW_BASE_DIR CREW_DOWNLOAD_BASE CREW_NDK_DIR


all: test
test: unit-tests rspec-tests

unit-tests:
	$(RUBY) -I ../library test_crew.rb

rspec-tests:
	$(RSPEC) $(rspec_files)
