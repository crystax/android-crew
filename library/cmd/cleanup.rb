require 'fileutils'
require_relative '../hold.rb'
require_relative '../formulary.rb'
require_relative '../formula.rb'


module Crew

  def self.cleanup(args)
    if args and args == '-n'
      dryrun = true
    else
      raise "this command accepts only one optional argument: -n"
    end

    Hold.new.installed.each_pair do |n, vers|
      Formulary.factory(n).exclude_latest(vers).each do |v|
        dir = Hold.release_directory(n, v)
        if (dryrun)
          puts "Would remove: #{dir}"
        else
          puts "Removing: #{dir}"
          FileUtils.remove_dir(dir)
        end
      end
    end
  end
end
