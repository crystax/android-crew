require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'


module Crew

  def self.install(args)
    if args.count < 1
      raise FormulaUnspecifiedError
    end

    args.each.with_index do |n, index|
      release = {}
      name, release[:version], release[:crystax_version] = n.split(':')
      formula = Formulary.factory(name)
      release = formula.find_release release

      hold = Hold.new
      if hold.installed?(name, release)
        puts "#{name}:#{release[:version]}:#{release[:crystax_version]} already installed"
        next
      end

      puts "calculating dependencies for #{name}: "
      deps, spacereq = formula.full_dependencies(hold, release)
      puts "  dependencies to install: #{deps.to_s.gsub('"', '')} "
      # todo: implement support
      # puts "  space required: #{spacereq}"

      if available_disk_space < spacereq
        raise "not enough disk space to install #{name} and it's dependencies"
      end

      if deps.count > 0
        puts "installing dependencies for #{name}:"
        deps.each do |d|
          f = Formulary.factory(d)
          f.install
        end
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
