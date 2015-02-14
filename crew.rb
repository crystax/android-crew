require_relative 'library/exceptions.rb'
require_relative 'library/global.rb'
require_relative 'library/formula.rb'


def require_command(cmd)
  require_relative File.join("library", "cmd", cmd + '.rb')
rescue LoadError => e
  # todo: raise unknown command only if file not found
  #raise UnknownCommand, cmd, e.backtrace
  raise
end


begin
  cmd = ARGV.size > 0 ? ARGV[0].to_s.gsub('-', '_').downcase : 'help'
  args = ARGV.slice(1, ARGV.length)

  require_command(cmd)
  Crew.send(cmd, args)

rescue CommandRequresNoArguments
  abort "This command requires no arguments"
rescue FormulaUnspecifiedError
  abort "This command requires a formula argument"
rescue Exception => e
  exception(e)
  exit 1
else
  #exit 1 if Crew.failed?
  # todo: 0 or 1 here?
  exit 0
end
