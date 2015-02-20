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
    maxname = 0
    maxver = 0
    formulas.each do |f|
      f.releases.each do |r|
        ver = r[:version]
        maxname = f.name.size if f.name.size > maxname
        maxlen = ver if ver.size > maxver
        list << Library.new(f.name, ver, hold.installed?(f.name, ver))
      end
    end

    list.each do |l|
      printf " %s %-#{maxname}s %-#{maxver}s\n", l.installed_sign, l.name, l.version
    end
  end
end
