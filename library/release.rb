class Release

  def initialize(ver = nil, cxver = nil, shasum = '0')
    cxver = cxver.to_i if cxver
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

  def installed?
    @r[:installed]
  end

  def shasum=(s)
    @r[:shasum] = s
  end

  def installed=(v)
    @r[:installed] = v
  end

  def update(hash)
    @r.update(hash)
  end

  def to_s
    "#{@r[:version]}_#{@r[:crystax_version]}"
  end

  # todo:
  # def ==(r)
  #   (version == r.version) and (crystax_version == r.crystax_version) and (shasum == r.shasum)
  # end
end
