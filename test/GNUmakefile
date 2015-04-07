unit_test_files = test_crew.rb

rspec_files = cmd_nocmd_spec.rb cmd_version_spec.rb cmd_help_spec.rb cmd_list_spec.rb cmd_info_spec.rb \
              cmd_cleanup_spec.rb cmd_install_spec.rb cmd_remove_spec.rb cmd_update_spec.rb            \
              cmd_upgrade_spec.rb

rspec_cmd_tests = $(patubst cmd_%_spec,test-%,$(basename $(rspec_files)))

#
# What we do to find ruby:
#  1. try environment varible
#  2. if env var is not set then suppose that crew is in NDK directory
#     and try ruby from tools dir
#  3. fallback to system ruby
#
ifdef CREW_RUBY_DIR
RUBY  = $(CREW_RUBY_DIR)/bin/ruby
RSPEC = $(CREW_RUBY_DIR)/bin/ruby $(CREW_RUBY_DIR)/bin/rspec
$(info Using path to ruby from environment: $(CREW_RUBY_DIR))
else ifneq ($(wildcard ../../tools/ruby),)
CREW_RUBY_DIR = $(realpath ../../tools/ruby)
RUBY  = $(CREW_RUBY_DIR)/bin/ruby
RSPEC = $(CREW_RUBY_DIR)/bin/ruby $(CREW_RUBY_DIR)/bin/rspec
$(info Using ruby form NDK: $(CREW_RUBY_DIR))
else
RUBY  = ruby
RSPEC = rspec
CREW_RUBY_DIR = $(dir $(dir $(shell which ruby)))
$(info Using system ruby: $(CREW_RUBY_DIR))
endif

CREW_BASE_DIR      = crew
CREW_DOWNLOAD_BASE = http://$(shell hostname -s):9999
CREW_NDK_DIR       = ndk

CREW_RUBY_VERSION = 2.2.0

export CREW_BASE_DIR CREW_DOWNLOAD_BASE CREW_NDK_DIR CREW_RUBY_DIR


.PHONY: all test clean dirs unit-tests rspec-tests $(rspec_cmd_tests)

all: test clean dirs

test: unit-tests rspec-tests

clean:
	$(RM) -rf crew crew.git ndk

unit-tests: dirs
	$(RUBY) -I ../library test_crew.rb

rspec-tests: dirs
	$(RSPEC) $(rspec_files)

test-%: dirs
	$(RSPEC) cmd_$*_spec.rb

dirs:
	-mkdir -p ndk/sources
	-mkdir -p crew/cache crew/formula
