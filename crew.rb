#!/usr/bin/env ruby

require_relative 'crew/command.rb'


begin
  cmd = ARGV[0].to_s.gsub('-', '_').downcase
  args = ARGV.slice(1, ARGV.length)

  Command.require_command(cmd)
  Crew.send(cmd, args)

rescue Exception => e
  exception(e)
  exit 1
else
  #exit 1 if Crew.failed?
  # todo: 0 or 1 here?
  exit 1
end
