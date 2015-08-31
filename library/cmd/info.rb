require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'
require_relative '../engine_room.rb'


module Crew

  def self.info(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    utils =  Formulary.utilities
    libs = Formulary.libraries

    args.each.with_index do |name, index|
      found = false
      # look for name in utities
      formula = utils[name]
      if formula
        found = true
        puts formula.to_info(utils)
      end
      # look for name in libraries
      formula = libs[name]
      if formula
        puts formula.to_info(libs)
      else
        raise FormulaUnavailableError.new(name) unless found
      end
      puts "" if index + 1 < args.count
    end
  end
end
