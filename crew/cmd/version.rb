module Crew

  def self.version(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end
    puts Global::CREW_VERSION
  end
end
