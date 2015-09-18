require_relative '../exceptions.rb'
require_relative '../formulary.rb'


module Crew

  def self.upgrade(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end

    names = []
    utils = []
    Formulary.utilities.each do |formula|
      if not formula.releases.last.installed?
        utils << formula
        names << last_release_name(formula)
      end
    end

    if utils.size > 0
      puts "Will install utilities: #{names.join(', ')}"
      utils.each do |formula|
        formula.install
        formula.link
      end
    end

    write_upgrade_script utils if Global::OS == 'windows'

    names = []
    libs = []
    Formulary.libraries.each do |formula|
      if formula.installed?
        if not formula.releases.last.installed?
          libs << formula
          names << last_release_name(formula)
        end
      end
    end

    if libs.size > 0
      puts "Will install: #{names.join(', ')}"
      libs.each { |formula| formula.install }
    end
  end

  private

  def self.last_release_name(formula)
    last_release = formula.releases.last
    "#{formula.name}:#{last_release.version}:#{last_release.crystax_version}"
  end

  def self.write_upgrade_script utils
    # todo: all
    raise "TODO: handle windows case for update utilities!"
  end
end
