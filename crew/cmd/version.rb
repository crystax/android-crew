module Crew

  VERSION = "0.0.2"

  def self.version(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end
    puts VERSION
  end
end
