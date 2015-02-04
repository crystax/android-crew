require_relative 'extend/module.rb'

class Formula

  # The name of this {Formula}.
  # e.g. `this-formula`
  attr_reader :name

  # The full path to this {Formula}.
  # e.g. `formula/this-formula.rb`
  attr_reader :path

  def initialize(name, path)
    @name = name
    @path = path
  end

  def homepage
    self.class.homepage
  end

  def releases
    self.class.releases
  end

  def dependencies
    self.class.dependencies ? self.class.dependencies : []
  end

  class Dependency

    def initialize(libname, options)
      #todo: check keys in options
      @options = options
      @options[:name] = libname
    end

    def libname
      @options[:name]
    end
  end

  class << self

    attr_rw :homepage

    attr_reader :releases, :dependencies

    def release(r)
      @releases = [] if !@releases
      # todo: check release keys in r
      @releases << r
      # todo: sort by version
    end

    def depends_on(libname, options = {})
      @dependencies = [] if !@dependencies
      @dependencies << Dependency.new(libname, options)
    end
  end
end
