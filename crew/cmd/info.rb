require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'


module Crew

  def self.info(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    hold = Hold.new

    args.each.with_index do |name, index|
      formula = Formulary.factory(name)
      puts "#{formula.name}: #{formula.homepage}"

      puts "releases:"
      formula.releases.each do |r|
        installed = hold.installed?(formula.name, r[:version]) ? "installed" : ""
        puts "  #{r[:version]}  #{installed}"
      end

      puts "dependencies:"
      formula.dependencies.each.with_index do |d, ind|
        prefix = ind > 0 ? ", " : ""
        installed = hold.installed?(d.libname) ? " (*)" : ""
        puts "  #{prefix}#{d.libname}#{installed}"
      end

      puts "" if index + 1 < args.count
    end
  end
end
