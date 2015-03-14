require 'pathname'

module Global

  def self.raise_env_var_not_set(var)
    raise "#{var} environment varible is not set"
  end

  def self.set_options(opts)
    opts.each do |o|
      case o
      when '--backtrace', '-b'
        @@options[:backtrace] = true
      else
        raise "unknown global option: #{o}"
      end
    end
  end

  def self.backtrace?
    @@options[:backtrace]
  end

  VERSION = "0.3.0"

  # :curl       -- curl will be run with --verbose options
  # :_7z        -- 7z will output files while unpacking
  # :temps      -- do not 'clean' in case of exceptions
  # :stdout     -- show output of the external commands executed
  DEBUG = []

  DOWNLOAD_BASE = ENV["CREW_DOWNLOAD_BASE"] or raise_env_var_not_set "CREW_DOWNLOAD_BASE"
  BASE_DIR = ENV["CREW_BASE_DIR"] or raise_env_var_not_set "CREW_BASE_DIR"
  NDK_DIR = ENV["CREW_NDK_DIR"] or raise_env_var_not_set "CREW_NDK_DIR"

  HOLD_DIR = Pathname.new(File.join(NDK_DIR, 'sources')).realpath
  FORMULA_DIR = Pathname.new(File.join(BASE_DIR, 'formula')).realpath
  CACHE_DIR = Pathname.new(File.join(BASE_DIR, 'cache')).realpath
  REPOSITORY_DIR = Pathname.new(BASE_DIR).realpath

  # todo: use progs included with NDK
  CREW_CURL_PROG = '/usr/bin/curl'
  CREW_7Z_PROG = '7z'

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

  private

  @@options = { backtrace: false }
end


def warning(msg)
  STDERR.puts "warning: #{msg}"
end


def error(msg)
  STDERR.puts "error: #{msg}"
end


def exception(exc)
  error(exc)
  STDERR.puts exc.backtrace if Global.backtrace?
end
