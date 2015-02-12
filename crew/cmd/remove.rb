require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'


module Crew

  def self.remove(args)
    if args.count < 1
      raise LibraryUnspecifiedError
    end

    formulary = Formulary.new

    args.each do |n|
      name, version = n.split(':')
      outname = name + ((version and version != 'all') ? ':' + version : "")

      hold = Hold.new
      if !hold.installed?(name, version)
        raise "library #{outname} not installed"
      end

      # todo: currently we do not care for version, only library name
      ideps = []
      formulary.dependants_of(name).each {|d| if hold.installed?(d.name); ideps << d.name end }
      if ideps.count > 0
        raise "library #{outname} has installed dependants: #{ideps}"
      end

      # NB: Hold.remove is clss method and does NOT updates hold internal data
      ivers = hold.installed_versions(name)
      # todo: assert(ivers.count > 0)
      if ivers.count == 1
        Hold.remove(name, ivers[0])
      elsif !version
        raise "more than one version of #{name} installed"
      else
        Hold.remove(name, version)
      end
    end
  end
end
