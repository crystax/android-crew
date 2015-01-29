CREW_HELP = <<-EOS
Usage: crew COMMAND [option]
where COMMAND is one of the following:
    version         output version information
    help            show this help message
    list            list all available libraries
    info libname    show information about the specified library
    install libname [version]
                    install the specified library
    uninstall libname [version|--all]
                    uninstall the specified library
    update          update crew repository information
    upgrade         install most recent versions
    cleanup [--dry-run]
                    uninstall old versions
EOS


module Crew
  def self.help(args)
    if args.length > 0
      raise CommandRequresNoArguments.new('help', args)
    end
    puts CREW_HELP
  end
end
