module Crew

  def self.info(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    utils =  Formulary.utilities
    libs = Formulary.libraries

    args.each.with_index do |name, index|
      # look for name in utities
      begin
        puts utils[name].to_info(utils)
        found = true
      rescue FormulaUnavailableError
        # ignore error
        found = false
      end
      # look for name in libraries
      begin
        puts libs[name].to_info(utils)
      rescue FormulaUnavailableError
        raise FormulaUnavailableError.new(name) unless found
      end
      puts "" if index + 1 < args.count
    end
  end
end
