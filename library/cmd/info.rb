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
      is_utility = false
      # look for name in utities
      begin
        formula = Formulary.factory(File.join(Global::UTILITIES_DIR, "#{name}.rb"))
        is_utility = true
        puts "#{formula.name}: #{formula.homepage}"
        puts "type: #{formula.type}"
        puts "releases:"
        formula.releases.each do |r|
          installed = engine_room.installed?(formula.name, r) ? "installed" : ""
          puts "  #{r[:version]} #{r[:crystax_version]}  #{installed}"
        end
      rescue FormulaUnavailableError
        # ignore error
      end

      # look for name in libraries
      begin
        formula = Formulary.factory(name)
        puts "#{formula.name}: #{formula.homepage}"
        puts "type: #{formula.type}"
        puts "releases:"
        formula.releases.each do |r|
          installed = hold.installed?(formula.name, r) ? "installed" : ""
          puts "  #{r[:version]} #{r[:crystax_version]}  #{installed}"
        end
        puts "dependencies:"
        formula.dependencies.each.with_index do |d, ind|
          installed = hold.installed?(d.name) ? " (*)" : ""
          puts "  #{d.name}#{installed}"
        end
      rescue FormulaUnavailableError
        raise unless is_utility
      end
      puts "" if index + 1 < args.count
    end
  end
end
