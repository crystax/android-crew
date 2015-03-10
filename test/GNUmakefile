unit_test_files = test_crew.rb

rspec_files = cmd_nocmd_spec.rb cmd_version_spec.rb cmd_help_spec.rb cmd_list_spec.rb cmd_info_spec.rb \
              cmd_cleanup_spec.rb cmd_install_spec.rb cmd_remove_spec.rb cmd_update_spec.rb            \
              cmd_upgrade_spec.rb


#
# What we do to find ruby:
#  1. try environment varible
#  2. if env var is not set then suppose that crew is in NDK directory
#     and try ruby from tools dir
#  3. fallback to system ruby
#
ifdef CREW_RUBY_BIN_DIR
RUBY  = $(CREW_RUBY_BIN_DIR)/ruby
RSPEC = $(CREW_RUBY_BIN_DIR)/rspec
$(info Using path to ruby from environment: $(CREW_RUBY_BIN_DIR))
else ifneq ($(wildcard ../../../tools/bin/ruby),)
CREW_RUBY_BIN_DIR = $(realpath $(../../../tools/bin))
RUBY  = $(CREW_RUBY_BIN_DIR)/ruby
RSPEC = $(CREW_RUBY_BIN_DIR)/rspec
$(info Using ruby form NDK: $(CREW_RUBY_BIN_DIR))
else
RUBY  = ruby
RSPEC = rspec
CREW_RUBY_BIN_DIR = $(dir $(shell which ruby))
$(info Using system ruby: $(CREW_RUBY_BIN_DIR))
endif

CREW_BASE_DIR      = crew
CREW_DOWNLOAD_BASE = http://127.0.0.1:9999
CREW_NDK_DIR       = ndk

export CREW_BASE_DIR CREW_DOWNLOAD_BASE CREW_NDK_DIR CREW_RUBY_BIN_DIR


all: test
test: unit-tests rspec-tests

unit-tests:
	$(RUBY) -I ../library test_crew.rb

rspec-tests:
	$(RSPEC) $(rspec_files)
