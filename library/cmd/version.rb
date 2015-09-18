require_relative '../exceptions.rb'
require_relative '../global.rb'

module Crew

  def self.version(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end
    puts Global::VERSION
  end
end
