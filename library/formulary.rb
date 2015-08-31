# The Formulary is a hash of formulas instances with formula name used as a key

require_relative 'exceptions.rb'
require_relative 'global.rb'

class Formulary

  def self.utilities
    Formulary.new(Global::UTILITIES_DIR)
  end

  def self.libraries
    Formulary.new(Global::FORMULA_DIR)
  end

  def initialize(dir)
    @formulary = {}
    Dir[File.join(dir, '*.rb')].each do |path|
      formula = Formulary.factory(path)
      @formulary[formula.name] = formula
    end
  end

  def each(&block)
    @formulary.each_value(&block)
  end

  def [](name)
    @formulary[name]
  end

  private

  def self.factory(path)
    Formulary.klass(path).new(path)
  end

  def self.klass(path)
    name = path_to_formula_name(path)
    raise FormulaUnavailableError.new(name) unless File.file? path

    mod = Module.new
    mod.module_eval(File.read(path), path)
    class_name = class_s(name)

    begin
      mod.const_get(class_name)
    rescue NameError => e
      raise FormulaUnavailableError, name, e.backtrace
    end
  end

  def self.class_s(name)
    class_name = name.capitalize
    class_name.gsub!(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }
    class_name.gsub!('+', 'x')
    class_name
  end

  def self.path_to_formula_name(path)
    File.basename(path, '.rb')
  end
end


#   def dependants_of(name)
#     list = []
#     @formulary.each do |f|
#       f.dependencies.each do |d|
#         if d.name == name
#           list << f
#           break
#         end
#       end
#     end
#     list
#   end


#   def self.loader_for(ref)
#     if File.extname(ref) == ".rb"
#       return FromPathLoader.new(ref)
#     end

#     return NullLoader.new(ref)
#   end



#   # A FormulaLoader returns instances of formula.
#   # Subclasses implement loaders for particular sources of formulae.
#   class FormulaLoader
#     # The formula's ruby file's path or filename
#     attr_reader :path
#     # The ruby constant name of the formula's class
#     attr_reader :class_name

#     def initialize(path)
#       @path = path
#       @class_name = Formulary.class_s(name)
#     end

#     # Gets the formula instance.
#     def get_formula
#       klass.new(path)
#     end

#     def klass
#       begin
#         have_klass = Formulae.formula_const_defined?(class_name)
#       rescue NameError => e
#         raise unless e.name.to_s == class_name
#         raise FormulaUnavailableError, name, e.backtrace
#       end

#       load_file unless have_klass

#       Formulae.formula_const_get(class_name)
#     end

#     private

#     def load_file
#       raise FormulaUnavailableError.new(name) unless path.file?
#       Formulae.module_eval(path.read, path.to_s)
#     end
#   end

#   # Loads formulae from disk using a path
#   class FromPathLoader < FormulaLoader
#     def initialize(path)
#       path = Pathname.new(path).expand_path
#       super path.basename(".rb").to_s, path
#     end
#   end

#   class NullLoader < FormulaLoader
#     def initialize(name)
#       @name = name
#     end

#     def get_formula
#       raise FormulaUnavailableError.new(name)
#     end
#   end

#   # Return a Formula instance for the given formula name.
#   # `ref` is string containing:
#   # * a formula name
#   # * a formula pathname

#   SPECIAL_NAMES = ['utilities']

#   def self.utilities
#     self.new(Global::UTILITIES_DIR, [])
#   end

#   def self.libraries
#     self.new(Global::FORMULA_DIR, SPECIAL_NAMES)
#   end


#   private

#   def self.formula_file?(name)
#     File.extname(name) == '.rb'
#   end
# end
