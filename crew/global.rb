module Global

  # todo: initialize correctly
  LIBRARY_DIR = '/Users/zuav/src/ndk/platform/ndk/sources'
  FORMULA_DIR = './formula'

  STANDARD_DIRS = ['android', 'cpufeatures', 'crystax', 'cxx-stl', 'host-tools', 'objc', 'third_party']

  def self.standard_dir?(name)
    STANDARD_DIRS.include?(name)
  end
end


def warning(msg)
  # todo: output if debug (or verbose?) mode set
  puts "warning: #{msg}"
end


def error(msg)
  puts "error: #{msg}"
  # todo: print backtrace only in debug mode
  puts e.backtrace
end


def exception(exc)
  puts "error: #{exc}"
  # todo: print backtrace only in debug mode
  puts exc.backtrace
end
