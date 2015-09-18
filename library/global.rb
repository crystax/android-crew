require 'pathname'

module Global

  private

  def self.check_program(prog)
    raise "#{prog} is not executable" unless prog.exist? and prog.executable?
  end

  def self.operating_system
    h = RUBY_PLATFORM.split('-')
    case h[1]
    when /linux/
      'linux'
    when /darwin/
      'darwin'
    when /mingw/
      'windows'
    else
      raise "unsupported host OS: #{h[1]}"
    end
  end

  def self.def_tools_dir(ndkdir, os)
    os64 = "#{os}-x86_64"
    os32 = (os == 'windows') ? "#{os}" : "#{os}-x86"

    dir64 = "#{ndkdir}/prebuilt/#{os64}"
    dir32 = "#{ndkdir}/prebuilt/#{os32}"

    Dir.exists?(dir64) ? dir64 : dir32
  end

  public

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
  OS = operating_system

  DOWNLOAD_BASE = ENV['CREW_DOWNLOAD_BASE'] ? ENV['CREW_DOWNLOAD_BASE'] : "https://crew.crystax.net:9876"
  BASE_DIR      = ENV['CREW_BASE_DIR']      ? Pathname.new(ENV['CREW_BASE_DIR']).realpath.to_s  : Pathname.new(__FILE__).realpath.dirname.dirname.to_s
  NDK_DIR       = ENV['CREW_NDK_DIR']       ? Pathname.new(ENV['CREW_NDK_DIR']).realpath.to_s   : Pathname.new(BASE_DIR).realpath.dirname.dirname.to_s
  TOOLS_DIR     = ENV['CREW_TOOLS_DIR']     ? Pathname.new(ENV['CREW_TOOLS_DIR']).realpath.to_s : def_tools_dir(NDK_DIR, OS)

  PLATFORM = File.basename(TOOLS_DIR)

  HOLD_DIR        = Pathname.new(File.join(NDK_DIR, 'sources')).realpath
  ENGINE_DIR      = Pathname.new(File.join(TOOLS_DIR, 'crew')).realpath
  FORMULA_DIR     = Pathname.new(File.join(BASE_DIR, 'formula')).realpath
  CACHE_DIR       = Pathname.new(File.join(BASE_DIR, 'cache')).realpath
  UTILITIES_DIR   = Pathname.new(File.join(FORMULA_DIR, 'utilities')).realpath
  REPOSITORY_DIR  = Pathname.new(BASE_DIR).realpath

  EXE_EXT = RUBY_PLATFORM =~ /mingw/ ? '.exe' : ''

  CREW_CURL_PROG = Pathname.new(File.join(TOOLS_DIR, 'bin')).realpath + "curl#{EXE_EXT}"
  CREW_7Z_PROG   = Pathname.new(File.join(TOOLS_DIR, 'bin')).realpath + "7za#{EXE_EXT}"

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
