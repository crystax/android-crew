require 'fileutils'
require_relative '../release.rb'
require_relative '../formulary.rb'

module Crew

  def self.cleanup(args)
    case args.length
    when 0
      dryrun = false
    when 1
      if args[0] == '-n'
        dryrun = true
      else
        raise "this command accepts only one optional argument: -n"
      end
    else
      raise "this command accepts only one optional argument: -n"
    end

    incache = []
    Formulary.utilities.each do |utility|
      utility.releases.each do |release|
        cachefile = utility.cache_file(release)
        if !utility.installed?(release) and File.exists?(cachefile)
          incache << cachefile
        end
        # todo: remove old release dirs
      end
    end

    Formulary.libraries.each do |formula|
      # releases are sorted from oldest to most recent order
      irels = []
      formula.releases.each do |release|
        if formula.installed?(release)
          irels << release
        else
          cachefile = formula.cache_file(release)
          incache << cachefile if File.exists?(cachefile)
        end
      end
      irels.pop
      irels.each do |release|
        cachefile = formula.cache_file(release)
        incache << cachefile if File.exists?(cachefile)
        dir = formula.release_directory(release)
        if (dryrun)
          puts "would remove: #{dir}"
        else
          puts "removing: #{dir}"
          FileUtils.remove_dir(dir)
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
