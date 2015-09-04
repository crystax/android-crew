class Element

  attr_reader :name, :version, :crystax_version, :installed_sign

  def initialize(name, version, cversion, iflag)
    @name = name
    @version = version
    @crystax_version = cversion
    @installed_sign = iflag ? '*' : ' '
  end
end


module Crew

  def self.list(args)
    case args.length
    when 0
      puts "Utilities:"
      list_elements Formulary.utilities
      puts "Libraries:"
      list_elements Formulary.libraries
    when 1
      case args[0]
      when 'utils'
        list_elements Formulary.utilities
      when 'libs'
        list_elements Formulary.libraries
      else
        raise "argument must either 'libs' or 'utils'"
      end
    else
      raise CommandRequresOneOrNoArguments
    end
  end

  private

  def self.list_elements(formulary)
    list = []
    max_name_len = max_ver_len = max_cxver_len = 0
    formulary.each do |f|
      f.releases.each do |r|
        max_name_len = f.name.size if f.name.size > max_name_len
        ver = r[:version]
        max_ver_len = ver.size if ver.size > max_ver_len
        cxver = r[:crystax_version]
        max_cxver_len = cxver.to_s.size if cxver.to_s.size > max_cxver_len
        list << Element.new(f.name, ver, cxver, f.installed?(r))
      end
    end

    list.each do |l|
      printf " %s %-#{max_name_len}s  %-#{max_ver_len}s  %-#{max_cxver_len}s\n", l.installed_sign, l.name, l.version, l.crystax_version
    end
  end
end
