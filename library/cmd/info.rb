require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'
require_relative '../engine_room.rb'


module Crew

  def self.info(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    engine_room = EngineRoom.new
    hold = Hold.new

    args.each.with_index do |name, index|
      found = false
      # look for name in utities
      begin
        formula = Formulary.factory(File.join(Global::UTILITIES_DIR, "#{name}.rb"))
        found = true
        puts formula.to_info(engine_room)
      rescue FormulaUnavailableError
        # ignore error; try to look for name in libraries
      end

      # look for name in libraries
      begin
        formula = Formulary.factory(name)
        puts formula.to_info(hold)
      rescue FormulaUnavailableError
        raise unless found
      end
      puts "" if index + 1 < args.count
    end
  end
end
