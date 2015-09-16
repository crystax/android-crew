class Release

  def initialize(ver, cxver, shasum = '0')
    @r = { version: ver, crystax_version: cxver, shasum: shasum }
  end

  def version
    @r[:version]
  end

  def crystax_version
    @r[:crystax_version]
  end

  def shasum
    @r[:shasum]
  end

  def shasum=(s)
    @r[:shasum] = s
  end

  def to_s
    "#{@r[:version]}_#{@r[:crystax_version]}"
  end

  def ==(r)
    (version == r.version) and (crystax_version == r.crystax_version) and (shasum == r.shasum)
  end
end
