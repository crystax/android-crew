#!/usr/bin/env ruby

require_relative 'crew/exceptions.rb'


LIB_PATH = "crew"


def require_command(cmd)
  require_relative File.join(LIB_PATH, "cmd", cmd + '.rb')
rescue LoadError => e
  raise UnknownCommand.new(cmd)
end


begin
  cmd = ARGV[0].to_s.gsub('-', '_').downcase
  args = ARGV.slice(1, ARGV.length)

  require_command(cmd)
  Crew.send(cmd, args)

rescue Exception => e
  puts "error: #{e}"
  # todo: print backtrace only in debug mode
  puts e.backtrace
  exit 1
else
  #exit 1 if Crew.failed?
  # todo: 0 or 1 here?
  exit 1
end
