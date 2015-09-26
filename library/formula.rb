require 'json'
require 'digest'
require 'fileutils'
require_relative 'extend/module.rb'
require_relative 'release.rb'
require_relative 'utils.rb'


class Formula

  PROPERTIES_FILE = 'properties.json'

  def self.package_version(release)
    release.to_s
  end

  def self.split_package_version(pkgver)
    r = pkgver.split('_')
    raise "bad package version string: #{pkgver}" if r.size < 2
    cxver = r.pop.to_i
    ver = r.join('_')
    Release.new(ver, cxver)
  end

  attr_reader :path

  def initialize(path)
    @path = path
    self.class.name File.basename(path, '.rb') unless name
    # mark installed releases
    releases.each do |r|
      dir = release_directory(r)
      if Dir.exists? dir
        prop = get_properties(dir)
        if r.crystax_version == prop[:crystax_version]
          r.update prop
          r.installed = true
        end
      end
    end
  end

  def name
    self.class.name
  end

  def desc
    self.class.desc
  end

  def homepage
    self.class.homepage
  end

  # NB: releases are stored in the order they're written in the formula file
  def releases
    self.class.releases
  end

  def dependencies
    self.class.dependencies ? self.class.dependencies : []
  end

  def full_dependencies(formulary, release)
    result = []
    size = 0 # todo: set to the size of the required release: {version:, crystax_version:}
    deps = dependencies

    while deps.size > 0
      n = deps.first.name
      deps = deps.slice(1, deps.size)
      f = formulary[n]
      next if f.installed?
      if !result.include?(f)
        result << f
        # todo: update size
      end
      deps += f.dependencies
    end

    [result, size]
  end

  def cache_file(release)
    File.join(Global::CACHE_DIR, archive_filename(release))
  end

  def install(r = releases.last)
    release = find_release(r)
    file = archive_filename(release)
    cachepath = File.join(Global::CACHE_DIR, file)

    if File.exists? cachepath
      puts "using cached file #{file}"
    else
      url = "#{download_base}/#{name}/#{file}"
      puts "downloading #{url}"
      Utils.download(url, cachepath)
    end

    puts "checking integrity of the archive file #{file}"
    if Digest::SHA256.hexdigest(File.read(cachepath, mode: "rb")) != release.shasum
      raise "bad SHA256 sum of the downloaded file #{cachepath}"
    end

    puts "unpacking archive"
    install_archive release_directory(release), cachepath
  end

  def uninstall(version)
    puts "removing #{name}-#{version}"
    dir = release_directory(Release.new(version))
    props = get_properties(dir)
    FileUtils.rm_rf dir
    releases.each do |r|
      if (r.version == version) and (r.crystax_version == props[:crystax_version])
        r.installed = false
        break
      end
    end
  end

  def installed?(release = Release.new)
    releases.any? { |r| r.match?(release) and r.installed? }
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

    attr_rw :name, :desc, :homepage, :space_reqired

    attr_reader :releases, :dependencies

    def release(r)
      raise ":version key not present in the release"         unless r.has_key?(:version)
      raise ":crystax_version key not present in the release" unless r.has_key?(:crystax_version)
      raise ":sha256 key not present in the release"          unless r.has_key?(:sha256)
      @releases = [] if !@releases
      @releases << Release.new(r[:version], r[:crystax_version], r[:sha256])
    end

    def depends_on(name, options = {})
      @dependencies = [] if !@dependencies
      @dependencies << Dependency.new(name, options)
    end
  end

  def to_info(formulary)
    info = "Name:        #{name}\n"     \
           "Formula:     #{path}\n"     \
           "Homepage:    #{homepage}\n" \
           "Description: #{desc}\n"     \
           "Type:        #{type}\n"     \
           "Releases:\n"
    releases.each do |r|
      installed = installed?(r) ? "installed" : ""
      info += "  #{r.version} #{r.crystax_version}  #{installed}\n"
    end
    if dependencies.size > 0
      info += "Dependencies:\n"
      dependencies.each.with_index do |d, ind|
        installed = formulary[d.name].installed? ? " (*)" : ""
        info += "  #{d.name}#{installed}"
      end
    end
    info
  end

  def find_release(release)
    rel = releases.reverse_each.find { |r| r.match?(release) }
    raise ReleaseNotFound.new(name, release) unless rel
    rel
  end

  private

  def get_properties(dir)
    # use full path here to get better error message if case open fails
    propfile = File.join(dir, PROPERTIES_FILE)
    JSON.parse(IO.read(propfile), symbolize_names: true)
  end
end
