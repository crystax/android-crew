module Global

  # :backtrace, :log
  $CREW_DEBUG = [:backtrace]

  # todo: initialize correctly
  HOLD_DIR = '/Users/zuav/tmp/crew/sources'
  FORMULA_DIR = 'formula'
end


def debug(msg)
  # todo: output if debug (or verbose?) mode set
  if $CREW_DEBUG.include?(:log)
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
  if $CREW_DEBUG.include?(:backtrace)
    puts exc.backtrace
  end
end
