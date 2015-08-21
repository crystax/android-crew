require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'


module Crew

  def self.remove(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    formulary = Formulary.new

    args.each do |n|
      # todo: handle all possible cases: name, name:ver, name:ver:cxver
      name, ver, cxver = n.split(':')
      # todo: fix outname
      outname = name + ((ver and ver != 'all') ? ':' + ver : "")

      hold = Hold.new
      if !hold.installed?(name, version: ver, crystax_version: cxver)
        raise "#{outname} not installed"
      end

      # currently we do not care for version, only formula name
      ideps = []
      ivers = hold.installed_versions(name)
      formulary.dependants_of(name).each {|d| if hold.installed?(d.name); ideps << d.name end }
      if ideps.count > 0 and ivers.count == 1
        raise "#{outname} has installed dependants: #{ideps}"
      end

      # NB: Hold.remove is a class method and does NOT updates hold internal data
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
