require_relative '../exceptions.rb'
require_relative '../hold.rb'
require_relative '../formulary.rb'


module Crew

  def self.upgrade(args)
    if args.length > 0
      raise CommandRequresNoArguments
    end

    names = []
    utils = []
    Formulary.utilities.each do |formula|
      last_release = formula.releases.last
      if !last_release[:installed]
        utils << formula
        names << "#{formula.name}:#{last_release[:version]}:#{last_release[:crystax_version]}"
      end
    end

    if utils.size > 0
      puts "Will upgrade: #{names.join(', ')}"
      utils.each do |formula|
        formula.install
        formula.link Global::NDK_DIR, File.basename(Global::TOOLS_DIR), formula.releases.last[:version] unless Global::OS == 'windows'
      end
    end

    write_upgrade_script utils if Global::OS == 'windows'

    names = []
    libs = []
    Formulary.libraries.each do |formula|
      if formula.installed?
        last_release = formula.releases.last
        if !formula.installed?(last_release)
          libs << formula
          names << "#{formula.name}:#{last_release[:version]}:#{last_release[:crystax_version]}"
        end
      end
    end

    if libs.size > 0
      puts "Will install: #{names.join(', ')}"
      libs.each { |formula| formula.install }
    end
  end

  private

  def write_upgrade_script utils
    # todo: all
  end
end
