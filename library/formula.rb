require 'digest'
require_relative 'extend/module.rb'
require_relative 'utils.rb'

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

  def full_dependencies(hold, version)
    result = []
    size = 0 # todo: set to the size of the required version
    deps = dependencies

    while deps.size > 0
      n = deps.first.name
      if hold.installed?(n)
        deps = deps.slice(1, deps.size)
        next
      end
      if !result.include?(n)
        result << n
        # todo: update size
      end
      f = Formulary.factory(n)
      deps = f.dependencies + deps.slice(1, deps.size)
    end

    [result, size]
  end

  def install(version = nil)
    rel = version ? (releases.select { |r| r[:version] == version })[0] : releases.last
    if !rel
      raise "#{name} does not have release with version #{version}"
    end

    file = filename(rel)
    url = "#{Global::DOWNLOAD_BASE}/#{file}"
    cachepath = File.join(Global::CACHE_DIR, file)
    if File.exists? cachepath
      puts "using cached file #{file}"
    else
      puts "downloading #{url}"
      Utils.download(url, cachepath)
    end

    puts "checking integrity of the downloaded file #{file}"
    sha256 = Digest::SHA256.hexdigest(File.read(cachepath))
    if Digest::SHA256.hexdigest(File.read(cachepath)) != rel[:sha256]
      raise "bad SHA256 sum of the downloaded file #{cachepath}"
    end

    Hold.install_release(name, rel[:version], cachepath)
    # todo: remove downloaded file in case of any exception; on not?
  end

  def latest_version
    releases.last[:version]
  end

  def exclude_latest(versions)
    lver = nil
    lind = -1
    versions.each do |v|
      ind = find_release_index_by_version(v)
      if ind > lind
        lind = ind
        lver = v
      end
    end
    versions.delete(lver)
    versions
  end

  class Dependency

    def initialize(name, options)
      @options = options
      @options[:name] = name
    end

    def name
      @options[:name]
    end
  end

  class << self

    attr_rw :homepage, :space_reqired

    attr_reader :releases, :dependencies

    def release(r)
      @releases = [] if !@releases
      check_required_keys(r)
      # NB: release are sorted in the order they're included into formula
      @releases << r
    end

    def depends_on(name, options = {})
      @dependencies = [] if !@dependencies
      @dependencies << Dependency.new(name, options)
    end

    private

    def check_required_keys(r)
      # todo: add filename?
      raise ":version key not present in the release" unless r.has_key?(:version)
      raise ":sha256 key not present in the release" unless r.has_key?(:sha256)
    end
  end

  private

  def filename(release)
    patch = release[:patch] ? "_#{release[:patch]}" : ""
    "#{name}-#{release[:version]}#{patch}.7z"
  end

  def find_release_index_by_version(version)
    releases.each.with_index do |rel, ind|
      if rel[:version] == version
        return ind
      end
    end
    raise "formula @{name} has no release with version #{version}"
  end
end
