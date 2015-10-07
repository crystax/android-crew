class Release

  def initialize(ver = nil, cxver = nil, sum = nil)
    cxver = cxver.to_i if cxver
    @r = { version: ver, crystax_version: cxver }
    @shasum = {}
    if sum.is_a? Hash
      @shasum.update(sum)
    else
      @shasum[:android] = sum
    end
  end

  def version
    @r[:version]
  end

  def crystax_version
    @r[:crystax_version]
  end

  def shasum(platform = :android)
    @shasum[platform]
  end

  def installed?
    @r[:installed]
  end

  # 's' must be either a hash like this { platform_name: 'sha256_sum' } or just a string
  def shasum=(s)
    if s.is_a? Hash
      @shasum.update(s)
    else
      @shasum[:android] = s
    end
  end

  def installed=(v)
    @r[:installed] = v
  end

  def update(hash)
    @r.update(hash)
  end

  def match?(r)
    ((version == r.version) or (version == nil) or (r.version == nil)) and ((crystax_version == r.crystax_version) or (crystax_version == nil) or (r.crystax_version == nil))
  end

  def to_s
    "#{@r[:version]}_#{@r[:crystax_version]}"
  end
end
