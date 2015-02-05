require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'


module Crew

  def self.install(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    hold = Hold.new

    args.each.with_index do |name, index|
      formula = Formulary.factory(name)
    end
  end
end
