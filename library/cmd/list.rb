require_relative '../exceptions.rb'
require_relative '../formulary.rb'
require_relative '../hold.rb'
require_relative '../engine_room.rb'


class Element

  attr_reader :name, :version, :crystax_version

  def initialize(name, version, cversion, iflag)
    @name = name
    @version = version
    @crystax_version = cversion
    @installed = iflag
  end

  def installed_sign
    @installed ? '*' : ' '
  end
end


module Crew

  def self.list(args)
    case args.length
    when 0
      puts "Utilities:"
      list_elements(EngineRoom.new, Formulary.read_utilities)
      puts "Libraries:"
      list_elements(Hold.new, Formulary.read_formulas)
    when 1
      case args[0]
      when 'libs'
        list_elements(Hold.new, Formulary.read_formulas)
      when 'utils'
        list_elements(EngineRoom.new, Formulary.read_utilities)
      else
        raise "argument must either 'libs' or 'utils'"
      end
    else
      raise CommandRequresOneOrNoArguments
    end
  end

  private

  def self.list_elements(room, formulas)
    list = []
    maxname = 0
    maxver = 0
    maxcxver = 0
    formulas.each do |f|
      f.releases.each do |r|
        maxname = f.name.size if f.name.size > maxname
        ver = r[:version]
        maxver = ver.size if ver.size > maxver
        cxver = r[:crystax_version]
        maxcxver = cxver.to_s.size if cxver.to_s.size > maxcxver
        list << Element.new(f.name, ver, cxver, room.installed?(f.name, ver, cxver))
      end
    end

    list.each do |l|
      printf " %s %-#{maxname}s  %-#{maxver}s  %-#{maxcxver}s\n", l.installed_sign, l.name, l.version, l.crystax_version
    end
  end
end
