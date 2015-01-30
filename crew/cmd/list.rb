require_relative '../command.rb'


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
    Command.check_args_is_empty(args)

    installed = Command.read_installed
    formulas = Command.read_formulas

    list = []
    formulas.each do |f|
      f.versions.each do |ver|
        iflag = installed.delete([f.name, ver]) != nil
        list << Library.new(f.name, ver, iflag)
      end
    end

    # todo: output as a table, count columns width's
    list.each do |l|
      puts "#{l.installed_sign}\t#{l.name}\t\t#{l.version}"
    end
  end
end
