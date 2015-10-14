unit_test_files = ts_crew.rb test_crew.rb test_release.rb

# skip network tests while we're not ready to update crew-test repository
# cmd_network_spec.rb
rspec_files = cmd_simple_spec.rb cmd_install_spec.rb cmd_remove_spec.rb cmd_list_spec.rb \
              cmd_info_spec.rb cmd_update_spec.rb cmd_upgrade_spec.rb cmd_cleanup_spec.rb

rspec_cmd_tests = $(patubst cmd_%_spec,test-%,$(basename $(rspec_files)))

ifeq ($(OS),Windows_NT)
  host_os = windows
else
  host_os = $(shell uname -s | tr '[:upper:]' '[:lower:]')
endif

ifneq ($(wildcard ../../../prebuilt/$(host_os)-x86_64),)
  TOOLS_DIR = $(realpath ../../../prebuilt/$(host_os)-x86_64)
  PLATFORM = $(host_os)-x86_64
else ifeq ($(host_os),windows)
  TOOLS_DIR = $(realpath ../../../prebuilt/$(host_os))/
  PLATFORM = $(host_os)
else
  TOOLS_DIR = $(realpath ../../../prebuilt/$(host_os)-x86)
  PLATFORM = $(host_os)-x86
endif

ifeq ($(host_os),windows)
  ruby_prog = ruby.exe
  ruby_version = $(shell $(TOOLS_DIR)/bin/awk "{print}" $(TOOLS_DIR)/crew/ruby/active_version.txt)
else
  ruby_prog = ruby
  ruby_version = $(shell cat $(TOOLS_DIR)/crew/ruby/active_version.txt)
endif

RUBY_DIR = $(TOOLS_DIR)/crew/ruby/$(ruby_version)/bin
RUBY     = $(RUBY_DIR)/$(ruby_prog)
RSPEC    = $(RUBY_DIR)/$(ruby_prog) $(RUBY_DIR)/rspec


CREW_BASE_DIR  = crew
CREW_NDK_DIR   = ndk
SSL_CERT_FILE  = $(abspath ../etc/ca-certificates.crt)


ifeq ($(host_os),windows)
  RM           = rd
  RMFLAGS      = /s/q
  MKDIR        = md
  MKDIRFLAGS   =
  NDKSRC_DIR   = ndk\sources
  CACHE_DIR    = crew\cache
  FORMULA_DIR  = crew\formula\utilities
  CREW_TOOLS_DIR = $(CREW_NDK_DIR)\prebuilt\$(PLATFORM)
  CREW_RUBY_DIR  = $(CREW_TOOLS_DIR)\bin
else
  RM             = rm
  MKDIR          = mkdir
  RMFLAGS        = -rf
  MKDIRFLAGS     = -p
  NDKSRC_DIR     = ndk/sources
  CACHE_DIR      = crew/cache
  FORMULA_DIR    = crew/formula/utilities
  CREW_TOOLS_DIR = $(CREW_NDK_DIR)/prebuilt/$(PLATFORM)
  CREW_RUBY_DIR  = $(CREW_TOOLS_DIR)/bin
endif


export CREW_BASE_DIR CREW_NDK_DIR CREW_TOOLS_DIR CREW_RUBY_DIR
export SSL_CERT_FILE


.PHONY: all test clean env test-data clean-test-data unit-tests rspec-tests $(rspec_cmd_tests)

all: test clean

test: test-data unit-tests rspec-tests

clean: clean-test-data
	$(RM) $(RMFLAGS) crew crew.git ndk

env:
	@echo CREW_BASE_DIR  = $(CREW_BASE_DIR)
	@echo CREW_NDK_DIR   = $(CREW_NDK_DIR)
	@echo CREW_TOOLS_DIR = $(CREW_TOOLS_DIR)
	@echo CREW_RUBY_DIR  = $(CREW_RUBY_DIR)

unit-tests: test-data $(unit_test_files)
	$(RUBY) -I ../library ts_crew.rb

test-data:
	$(RUBY) test_prepare.rb

clean-test-data:
	$(RUBY) test_cleanup.rb

rspec-tests: test-data
	$(RSPEC) $(rspec_files)

test-%:
	$(RSPEC) cmd_$*_spec.rb

shell:
	@PS1="[$(PS1) crew test] " bash

env:
