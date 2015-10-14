require_relative '../exceptions.rb'
require_relative '../release.rb'
require_relative '../formulary.rb'


module Crew

  def self.remove(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    formulary = Formulary.libraries

    args.each do |n|
      name, version = n.split(':')
      outname = name + ((version and version != 'all') ? ':' + version : "")

      formula = formulary[name]
      release = (version == 'all') ? Release.new : Release.new(version)
      if !formula.installed?(release)
        raise "#{outname} not installed"
      end

      # currently we do not care for dependency version, only formula name
      ivers = (formula.releases.map { |r| r.installed? ? r.version : nil }).compact
      ideps = formulary.dependants_of(name).select { |f| f.installed? }
      if ideps.count > 0 and (ivers.count == 1 or version == 'all')
        raise "#{outname} has installed dependants: #{ideps.map{|f| f.name}.join(', ')}"
      end

      if ivers.count == 1
        formula.uninstall(ivers[0])
      elsif !version
        raise "more than one version of #{name} installed"
      elsif version != 'all'
        formula.uninstall(version)
      else
        ivers.each { |v| formula.uninstall(v) }
      end
    end
  end
end
