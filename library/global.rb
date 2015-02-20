require 'pathname'

module Global

  def self.raise_env_var_not_set(var)
    raise "#{var} environment varible is not set"
  end

  VERSION = "0.1.0"

  # :backtrace  -- output backgtrace with exception message
  # :log        -- debug function will output it's message
  # :curl       -- curl will be run with --verbose options
  # :_7z        -- 7z will output files while unpacking
  # :temps      -- do not 'clean' in case of exceptions
  # :stdout     -- show output of the external commands executed
  DEBUG = [:backtrace]

  DOWNLOAD_BASE = ENV["CREW_DOWNLOAD_BASE"] or raise_env_var_not_set "CREW_DOWNLOAD_BASE"
  BASE_DIR = ENV["CREW_BASE_DIR"] or raise_env_var_not_set "CREW_BASE_DIR"
  NDK_DIR = ENV["CREW_NDK_DIR"] or raise_env_var_not_set "CREW_NDK_DIR"

  HOLD_DIR = Pathname.new(File.join(NDK_DIR, 'sources')).realpath
  FORMULA_DIR = Pathname.new(File.join(BASE_DIR, 'formula')).realpath
  CACHE_DIR = Pathname.new(File.join(BASE_DIR, 'cache')).realpath
  REPOSITORY_DIR = Pathname.new(BASE_DIR).realpath

  # todo: use progs included with NDK
  CREW_CURL_PROG = '/usr/bin/curl'
  CREW_7Z_PROG = '/usr/local/bin/7z'

  # todo:
  if RUBY_PLATFORM =~ /darwin/
    MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
    MACOS_VERSION = MACOS_FULL_VERSION[/10\.\d+/]
    OS_VERSION = "Mac OS X #{MACOS_FULL_VERSION}"
  else
    MACOS_FULL_VERSION = MACOS_VERSION = "0"
    OS_VERSION = RUBY_PLATFORM
  end

  USER_AGENT = "Crystax NDK Crew #{VERSION}"
end


def debug(msg)
  # todo: output if debug (or verbose?) mode set
  if Global::DEBUG.include?(:log)
    puts "debug: #{msg}"
  end
end


def warning(msg)
  # todo: output if debug (or verbose?) mode set
  puts "warning: #{msg}"
end


def error(msg)
  STDERR.puts "error: #{msg}"
end


def exception(exc)
  error(exc)
  # todo: print backtrace only in debug mode
  if Global::DEBUG.include?(:backtrace)
    STDERR.puts exc.backtrace
  end
end
