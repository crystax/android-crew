class Formula

  attr_reader :name

  def initialize(name, ver)
    @name = name
    @versions = [ver]
  end

  def versions
    @versions
  end
end
