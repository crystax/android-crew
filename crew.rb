#!/usr/bin/env ruby

require_relative 'crew/exceptions.rb'
require_relative 'crew/global.rb'
require_relative 'crew/formula.rb'


def require_command(cmd)
  require_relative File.join("crew", "cmd", cmd + '.rb')
rescue LoadError => e
  # todo: raise unknown command only if file not found
  #raise UnknownCommand, cmd, e.backtrace
  raise
end


begin
  cmd = ARGV[0].to_s.gsub('-', '_').downcase
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
  exit 1
end
