module Global

  # todo: initialize correctly
  LIBRARY_DIR = '/Users/zuav/src/ndk/platform/ndk/sources'
  HOLD_DIR = '/Users/zuav/src/ndk/platform/ndk/sources'
  FORMULA_DIR = 'formula'

end


def debug(msg)
  # todo: output if debug (or verbose?) mode set
  if $DEBUG
    puts "debug: #{msg}"
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
