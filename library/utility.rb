require_relative 'formula.rb'


class Utility < Formula

  def self.programs(*args)
    if args.size == 0
      @programs ? @programs : []
    else
      @programs = args
    end
  end

  # formula's ctor marked as 'installed' all releases that are unpacked (resp. dir exixts)
  # but for utilities a release considered 'installed' only if it's version is equal
  # to the one saved in the 'active' file
  #
  # formula's ctor called with :no_active_file from the NDK's build scripts
  # in tht case we should just mark all releases as 'uninstalled'
  def initialize(path, *options)
    super(path)

    if options.include? :no_active_file
      releases.each { |r| r.installed = false }
    else
      active_version = Global::active_util_version(name)
      releases.each { |r| r.installed = (r.to_s == active_version) }
    end
  end

  def programs
    self.class.programs
  end

  def release_directory(release)
    File.join(Global::ENGINE_DIR, name, release.to_s)
  end

  def download_base
    "#{Global::DOWNLOAD_BASE}/utilities"
  end

  def type
    :utility
  end

  private

  def archive_filename(release)
    "#{name}-#{Formula.package_version(release)}-#{Global::PLATFORM}.tar.xz"
  end

  def sha256_sum(release)
    release.shasum(Global::PLATFORM.gsub(/-/, '_').to_sym)
  end

  def install_archive(outdir, archive)
    FileUtils.rm_rf outdir
    FileUtils.mkdir_p outdir
    Utils.unpack(archive, Global::NDK_DIR)
    write_active_file(File.basename(outdir))
  end

  def write_active_file(version)
    File.open(Global.active_file_path(name), 'w') { |f| f.puts version }
  end
end
