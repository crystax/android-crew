require_relative '../exceptions.rb'


module Crew

  VERSION = "0.0.1"

  def self.version(args)
    if args.length > 0
      raise CommandRequresNoArguments.new('version', args)
    end
    puts VERSION
  end
end
