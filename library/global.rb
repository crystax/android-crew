require 'pathname'

module Global

  def raise_env_var_not_set(var)
    raise "#{var} environment varible is not set"
  end

  VERSION = "0.1.0"

  # :backtrace  -- output backgtrace with exception message
  # :log        -- debug function will output it's message
  # :curl       -- curl will be run with --verbose options
  # :_7z        -- 7z will output files while unpacking
  # :temps      -- do not 'clean' in case of exceptions
  # :stdout     -- show output of the external commands executed
  CREW_DEBUG = [:backtrace]

  DOWNLOAD_BASE = ENV["CREW_DOWNLOAD_BASE"] or raise_env_var_not_set "CREW_DOWNLOAD_BASE"

  # todo: initialize correctly
  HOLD_DIR = '/Users/zuav/tmp/crew/sources'
  FORMULA_DIR = 'formula'
  CACHE_DIR = 'cache'
  CREW_REPOSITORY_DIR = Pathname.new('.').realpath

  # todo: use progs included with NDK
  CREW_CURL_PROG = '/usr/bin/curl'
  CREW_7Z_PROG = '/usr/local/bin/7z'

  if RUBY_PLATFORM =~ /darwin/
    MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
    MACOS_VERSION = MACOS_FULL_VERSION[/10\.\d+/]
    OS_VERSION = "Mac OS X #{MACOS_FULL_VERSION}"
  else
    MACOS_FULL_VERSION = MACOS_VERSION = "0"
    OS_VERSION = RUBY_PLATFORM
  end

  # todo:
  #USER_AGENT = "Crew #{CREW_VERSION} (Ruby #{RUBY_VERSION}-#{RUBY_PATCHLEVEL}; #{OS_VERSION})"
  USER_AGENT = "Crew #{VERSION}"
end


def debug(msg)
  # todo: output if debug (or verbose?) mode set
  if Global::CREW_DEBUG.include?(:log)
    puts "debug: #{msg}"
  end
end


def warning(msg)
  # todo: output if debug (or verbose?) mode set
  puts "warning: #{msg}"
end


def error(msg)
  puts "error: #{msg}"
end


def exception(exc)
  error(exc)
  # todo: print backtrace only in debug mode
  if Global::CREW_DEBUG.include?(:backtrace)
    puts exc.backtrace
  end
end
