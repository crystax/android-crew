require_relative '../exceptions.rb'
require_relative '../release.rb'
require_relative '../formulary.rb'


module Crew

  def self.install(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    formulary = Formulary.libraries

    args.each.with_index do |n, index|
      name, ver, cxver = n.split(':')
      formula = formulary[name]
      release = formula.find_release Release.new(ver, cxver)

      if formula.installed?(release)
        puts "#{name}:#{release.version}:#{release.crystax_version} already installed"
        next
      end

      puts "calculating dependencies for #{name}: "
      deps, spacereq = formula.full_dependencies(formulary, release)
      puts "  dependencies to install: #{(deps.map { |d| d.name }).join(', ')}"
      # todo: implement support
      # puts "  space required: #{spacereq}"

      if available_disk_space < spacereq
        raise "not enough disk space to install #{name} and it's dependencies"
      end

      if deps.count > 0
        puts "installing dependencies for #{name}:"
        deps.each { |d| d.install }
        puts""
      end

      formula.install release

      puts "" if index + 1 < args.count
    end
  end

  def self.available_disk_space
    # todo: all
    1
  end
end
