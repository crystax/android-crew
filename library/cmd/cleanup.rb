require 'fileutils'
require_relative '../hold.rb'
require_relative '../formulary.rb'


module Crew

  def self.cleanup(args)
    if args.length > 0
      if args[0] == '-n'
        dryrun = true
      else
        raise "this command accepts only one optional argument: -n"
      end
    end

    incache = []
    Hold.new.installed.each_pair do |n, props|
      formula = Formulary.factory(n)
      formula.exclude_latest(props).each do |r|
        dir = Hold.release_directory(n, r[:version])
        if (dryrun)
          puts "would remove: #{dir}"
        else
          puts "removing: #{dir}"
          FileUtils.remove_dir(dir)
        end
        archive = formula.cache_file(r)
        if File.exists?(archive)
          incache << archive
        end
      end
    end
    incache.each do |f|
      if (dryrun)
        puts "would remove: #{f}"
      else
        puts "removing: #{f}"
        FileUtils.remove_file(f)
      end
    end
  end
end
