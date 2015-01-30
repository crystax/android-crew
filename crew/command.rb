require 'fileutils'
require_relative 'exceptions.rb'
require_relative 'global.rb'
require_relative 'formula.rb'


module Command

  def self.require_command(cmd)
    require_relative File.join("cmd", cmd + '.rb')
  rescue LoadError => e
    raise UnknownCommand.new(cmd)
  end

  def self.check_args_is_empty(args)
    if args.length > 0
      raise CommandRequresNoArguments.new('help', args)
    end
  end

  #
  # return list of pairs [name, version]
  #
  def self.read_installed
    list = []
    FileUtils.cd(Global::LIBRARY_DIR) {
      Dir.foreach('.') do |name|
        if name == '.' or name == '..' or !File.directory?(name) or Global.standard_dir?(name)
          next
        end
        FileUtils.cd(name) {
          Dir.foreach('.') do |ver|
            if ver == '.' or ver == '..'
              next
            end
            if !File.directory?(ver)
              warning "directory #{File.join(Global::LIBRARY_DIR, name)} contains foreign object #{ver}"
            end
            # todo: create version object
            list << [name, ver]
          end
        }
      end
    }
    list
  end

  #
  # return list of all formulas
  #
  def self.read_formulas
    # list = []
    # Dir.foreach(Global::FORMULA_DIR) do |item|
    #   if item == '.' or item == '..'
    #     next
    #   end
    #   list << Formula.new(item)
    # end
    # list
    [Formula.new("boost", "1.57.0"), Formula.new("icu", "54.1")]
  end
end
