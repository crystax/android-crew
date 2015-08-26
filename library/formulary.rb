# This file was copied from homebrew sources verbatim.
# After that it was changed.

# The Formulary is responsible for creating instances of Formula.
# It is not meant to be used directy from formulae.

require 'pathname'
require_relative 'exceptions.rb'
require_relative 'global.rb'

class Formulary
  module Formulae
    class << self
      if instance_method(:const_defined?).arity == -1
        def formula_const_defined?(name)
          const_defined?(name, false)
        end

        def formula_const_get(name)
          const_get(name, false)
        end
      else
        def formula_const_defined?(name)
          const_defined?(name)
        end

        def formula_const_get(name)
          const_get(name)
        end
      end

      def remove_formula_const(name)
        remove_const(name)
      end

      def formula_const_set(name, value)
        const_set(name, value)
      end
    end
  end

  def self.unload_formula(formula_name)
    Formulae.remove_formula_const(class_s(formula_name))
  end

  def self.restore_formula(formula_name, value)
    old_verbose, $VERBOSE = $VERBOSE, nil
    Formulae.formula_const_set(class_s(formula_name), value)
  ensure
    $VERBOSE = old_verbose
  end

  def self.class_s(name)
    class_name = name.capitalize
    class_name.gsub!(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }
    class_name.gsub!('+', 'x')
    class_name
  end

  # A FormulaLoader returns instances of formulae.
  # Subclasses implement loaders for particular sources of formulae.
  class FormulaLoader
    # The formula's name
    attr_reader :name
    # The formula's ruby file's path or filename
    attr_reader :path
    # The ruby constant name of the formula's class
    attr_reader :class_name

    def initialize(name, path)
      @name = name
      # todo: do we need special treatment for symlinks here?
      #@path = path.resolved_path
      @path = path
      @class_name = Formulary.class_s(name)
    end

    # Gets the formula instance.
    def get_formula
      klass.new(name, path)
    end

    def klass
      begin
        have_klass = Formulae.formula_const_defined?(class_name)
      rescue NameError => e
        raise unless e.name.to_s == class_name
        raise FormulaUnavailableError, name, e.backtrace
      end

      load_file unless have_klass

      Formulae.formula_const_get(class_name)
    end

    private

    def load_file
      raise FormulaUnavailableError.new(name) unless path.file?
      Formulae.module_eval(path.read, path.to_s)
    end
  end

  # Loads formulae from disk using a path
  class FromPathLoader < FormulaLoader
    def initialize(path)
      path = Pathname.new(path).expand_path
      super path.basename(".rb").to_s, path
    end
  end

  class NullLoader < FormulaLoader
    def initialize(name)
      @name = name
    end

    def get_formula
      raise FormulaUnavailableError.new(name)
    end
  end

  # Return a Formula instance for the given formula name.
  # `ref` is string containing:
  # * a formula name
  # * a formula pathname
  def self.factory(ref)
    loader_for(ref).get_formula
  end

  def self.loader_for(ref)
    if File.extname(ref) == ".rb"
      return FromPathLoader.new(ref)
    end

    path = Pathname.new("#{Global::FORMULA_DIR}/#{ref.downcase}.rb")
    if path.file?
      return FormulaLoader.new(ref, path)
    end

    return NullLoader.new(ref)
  end

  SPECIAL_NAMES = ['utilities']

  # todo: write iterator
  def self.read_formulas
    read_dir_with_formulas(Global::FORMULA_DIR, SPECIAL_NAMES)
  end

  def self.read_utilities
    read_dir_with_formulas(Global::UTILITIES_DIR, [])
  end

  def initialize
    @formulary = []
    Dir.foreach(Global::FORMULA_DIR) do |name|
      if name == '.' or name == '..'
        next
      end
      if self.class.formula_file?(name)
        @formulary << self.class.factory(File.join(Global::FORMULA_DIR, name))
      elsif !SPECIAL_NAMES.include?(name)
        warning("not a formula file in formula dir: #{name}")
      end
    end
  end

  def dependants_of(name)
    list = []
    @formulary.each do |f|
      f.dependencies.each do |d|
        if d.name == name
          list << f
          break
        end
      end
    end
    list
  end

  private

  def self.formula_file?(name)
    File.extname(name) == '.rb'
  end

  def self.read_dir_with_formulas(dir, exceptions)
    list = []
    Dir.foreach(dir) do |name|
      if name == '.' or name == '..'
        next
      end
      if formula_file?(name)
        list << factory(File.join(dir, name))
      elsif !exceptions.include?(name)
        warning("garbage in a formula dir #{dir}: #{name}")
      end
    end
    list
  end
end
