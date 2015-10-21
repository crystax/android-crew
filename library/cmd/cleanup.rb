require 'fileutils'
require_relative '../release.rb'
require_relative '../formulary.rb'
require_relative '../library.rb'
require_relative '../utility.rb'

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
    Formulary.utilities.each { |formula| incache += remove_old_utilities(formula, dryrun) }
    Formulary.libraries.each { |formula| incache += remove_old_libraries(formula, dryrun) }

    incache.each do |f|
      if (dryrun)
        puts "would remove: #{f}"
      else
        puts "removing: #{f}"
        FileUtils.remove_file(f)
      end
    end
  end

  # private

  def self.remove_old_utilities(formula, dryrun)
    # releases are sorted from oldest to most recent order
    incache = []
    irels = []
    formula.releases.each do |release|
      if not release.installed?
        # archives for not installed releases should be removed during cleanup
        cachefile = formula.cache_file(release)
        incache << cachefile if File.exists?(cachefile)
        if Dir.exists?(formula.release_directory(release))
          irels << release
        end
      end
    end
    irels.each do |release|
      dir = formula.release_directory(release)
      if (dryrun)
        puts "would remove: #{dir}"
      else
        puts "removing: #{dir}"
        FileUtils.rm_rf(dir)
      end
    end

    incache
  end

  def self.remove_old_libraries(formula, dryrun)
    # releases are sorted from oldest to most recent order
    incache = []
    irels = []
    formula.releases.each do |release|
      if release.installed?
        irels << release
      else
        # archives for not installed releases should be removed during cleanup
        cachefile = formula.cache_file(release)
        incache << cachefile if File.exists?(cachefile)
      end
    end
    irels.pop # exclude latest release
    irels.each do |release|
      cachefile = formula.cache_file(release)
      incache << cachefile if File.exists?(cachefile)
      dir = formula.release_directory(release)
      if (dryrun)
        puts "would remove: #{dir}"
      else
        puts "removing: #{dir}"
        FileUtils.rm_rf(dir)
      end
    end

    incache
  end
end
