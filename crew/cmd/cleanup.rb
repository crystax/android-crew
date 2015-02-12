require 'fileutils'
require_relative '../hold.rb'
require_relative '../formulary.rb'
require_relative '../formula.rb'


module Crew

  def self.cleanup(args)
    dryrun = args ? args.delete("-n") : false
    names = (args and args.size > 0) ? args : nil
    Hold.new.select(names).each_pair do |n, vers|
      _, rest = Formulary.factory(n).latest_version(vers)
      rest.each do |v|
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
