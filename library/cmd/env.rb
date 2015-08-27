module Crew

  def self.env(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end
    puts "DOWNLOAD_BASE: #{Global::DOWNLOAD_BASE}"
    puts "BASE_DIR:      #{Global::BASE_DIR}"
    puts "NDK_DIR:       #{Global::NDK_DIR}"
    puts "TOOLS_DIR:     #{Global::TOOLS_DIR}"
  end
end
