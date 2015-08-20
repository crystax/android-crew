require_relative '../exceptions.rb'
require_relative '../hold.rb'
require_relative '../formulary.rb'


module Crew

  def self.upgrade(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end

    list = []
    Hold.new.installed.each_pair do |name, ivers|
      formula = Formulary.factory(name)
      lver = formula.latest_version
      list << [name, lver] unless ivers.include?(lver)
    end

    if list.size > 0
      str = list.map{|e| e.join('-') }.join(' ')
      puts "Will install: #{str}"
      list.each do |pair|
        name, ver = pair
        Formulary.factory(name).install(ver)
      end
    end
  end
end
