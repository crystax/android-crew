require 'fileutils'
require_relative '../hold.rb'
require_relative '../formulary.rb'
require_relative '../formula.rb'


module Crew

  def self.cleanup(args)
    if args.length > 0
      if args[0] == '-n'
        dryrun = true
      else
        raise "this command accepts only one optional argument: -n"
      end
    end

    Hold.new.installed.each_pair do |n, vers|
      Formulary.factory(n).exclude_latest(vers).each do |v|
        dir = Hold.release_directory(n, v)
        if (dryrun)
          puts "would remove: #{dir}"
        else
          puts "removing: #{dir}"
          FileUtils.remove_dir(dir)
        end
      end
    end
  end
end
