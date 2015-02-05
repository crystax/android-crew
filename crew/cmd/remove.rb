require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'


module Crew

  def self.remove(args)
    if args.count < 1
      raise LibraryUnspecifiedError
    end

    formulary = Formulary.new

    args.each do |name|
      libname, version = name.split(':')
      outname = libname + ((version and version != 'all') ? ':' + version : "")

      hold = Hold.new
      if !hold.installed?(libname, version)
        raise "library #{outname} not installed"
      end

      # todo: currently we do not care for version, only library name
      ideps = []
      formulary.dependants_of(libname).each {|d| if hold.installed?(d.name); ideps << d.name end }
      if ideps.count > 0
        raise "library #{outname} has installed dependants: #{ideps}"
      end

      ivers = hold.installed_versions(libname)
      # todo: assert(ivers.count > 0)
      if ivers.count == 1
        hold.remove_library(libname, ivers[0])
      elsif !version
        raise "more than one version of #{libname} installed"
      else
        hold.remove_library(libname, version)
      end
    end
  end
end
