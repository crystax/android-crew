unit_test_files = test_crew.rb

# skip network tests while we're not ready to update crew-test repository
# cmd_network_spec.rb
rspec_files = cmd_nocmd_spec.rb cmd_version_spec.rb cmd_help_spec.rb cmd_env_spec.rb   \
              cmd_install_spec.rb cmd_remove_spec.rb cmd_list_spec.rb cmd_info_spec.rb \
              cmd_update_spec.rb cmd_upgrade_spec.rb

#cmd_cleanup_spec.rb

rspec_cmd_tests = $(patubst cmd_%_spec,test-%,$(basename $(rspec_files)))

ifeq ($(OS),Windows_NT)
  host_os = windows
else
  host_os = $(shell uname -s | tr '[:upper:]' '[:lower:]')
endif

ifeq ($(host_os),windows)
  ruby_prog = ruby.exe
else
  ruby_prog = ruby
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

RUBY_DIR = $(TOOLS_DIR)/bin

RUBY  = $(RUBY_DIR)/$(ruby_prog)
RSPEC = $(RUBY_DIR)/$(ruby_prog) $(RUBY_DIR)/rspec


CREW_BASE_DIR  = crew
CREW_NDK_DIR   = ndk
CREW_TOOLS_DIR = $(CREW_NDK_DIR)/prebuilt/$(PLATFORM)
CREW_RUBY_DIR  = $(CREW_TOOLS_DIR)/bin

SSL_CERT_FILE = $(abspath ../etc/ca-certificates.crt)


ifeq ($(host_os),windows)
  RM          = rd
  RMFLAGS     = /s/q
  MKDIR       = md
  MKDIRFLAGS  =
  NDKSRC_DIR  = ndk\sources
  CACHE_DIR   = crew\cache
  FORMULA_DIR = crew\formula\utilities
else
  RM          = rm
  MKDIR       = mkdir
  RMFLAGS     = -rf
  MKDIRFLAGS  = -p
  NDKSRC_DIR  = ndk/sources
  CACHE_DIR   = crew/cache
  FORMULA_DIR = crew/formula/utilities
endif


export CREW_BASE_DIR CREW_NDK_DIR CREW_TOOLS_DIR CREW_RUBY_DIR
export SSL_CERT_FILE


.PHONY: all test clean dirs test-data clean-test-data unit-tests rspec-tests $(rspec_cmd_tests)

all: test clean dirs

test: test-data unit-tests rspec-tests

clean: clean-test-data
	$(RM) $(RMFLAGS) crew crew.git ndk

unit-tests: dirs
	$(RUBY) -I ../library test_crew.rb

test-data:
	$(RUBY) test_prepare.rb

clean-test-data:
	$(RUBY) test_cleanup.rb

rspec-tests: dirs
	$(RSPEC) $(rspec_files)

test-%:
	$(RSPEC) cmd_$*_spec.rb

dirs:
	-$(MKDIR) $(MKDIRFLAGS) $(NDKSRC_DIR)
	-$(MKDIR) $(MKDIRFLAGS) $(CACHE_DIR)
	-$(MKDIR) $(MKDIRFLAGS) $(FORMULA_DIR)

shell:
	@PS1="[$(PS1) crew test] " bash
