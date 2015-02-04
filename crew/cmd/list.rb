require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'


class Library

  attr_reader :name, :version

  def initialize(name, version, iflag)
    @name = name
    @version = version
    @installed = iflag
  end

  def installed_sign
    @installed ? '*' : ' '
  end
end


module Crew

  def self.list(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end

    hold = Hold.new
    formulas = Formulary.read_all

    list = []
    formulas.each do |f|
      f.releases.each do |r|
        ver = r[:version]
        list << Library.new(f.name, ver, hold.installed?(f.name, ver))
      end
    end

    # todo: output as a table, count columns width's
    list.each do |l|
      puts "#{l.installed_sign}\t#{l.name}\t\t#{l.version}"
    end
  end
end
