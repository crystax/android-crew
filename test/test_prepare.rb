require 'fileutils'
require 'digest'
require 'pathname'
require 'json'
require_relative '../library/release.rb'
require_relative '../library/utils.rb'
require_relative 'test_consts.rb'


tools_dir          = ENV['CREW_TOOLS_DIR']
PLATFORM           = File.basename(tools_dir)
utils_download_dir = File.join(Crew_test::DOCROOT_DIR, 'utilities')
orig_ndk_dir       = File.join('..', '..', '..')
orig_tools_dir     = File.join(orig_ndk_dir, 'prebuilt', PLATFORM)

# copy utils from NDK dir to tests directory structure
FileUtils.mkdir_p File.dirname(File.join(tools_dir, 'crew'))
FileUtils.mkdir_p utils_download_dir
FileUtils.cp_r File.join(orig_tools_dir, 'crew'), File.join(tools_dir, 'crew')
FileUtils.cp_r File.join(orig_tools_dir, 'bin'),  tools_dir

ORIG_NDK_DIR       = Pathname.new(orig_ndk_dir).realpath.to_s
ORIG_TOOLS_DIR     = Pathname.new(orig_tools_dir).realpath.to_s
ORIG_FORMULA_DIR   = Pathname.new(File.join(orig_ndk_dir, 'tools', 'crew', 'formula', 'utilities')).realpath.to_s
TOOLS_DIR          = Pathname.new(tools_dir).realpath.to_s
UTILS_DOWNLOAD_DIR = Pathname.new(utils_download_dir).realpath.to_s
DATA_DIR           = Pathname.new(Crew_test::DATA_DIR).realpath.to_s
NDK_DIR            = Pathname.new(Crew_test::NDK_DIR).realpath.to_s


def replace_releases(formula, releases)
  lines = []
  replaced = false
  File.foreach(formula) do |l|
    if l !~ /release/
      lines << l
    elsif !replaced
      releases.each { |r| lines << "  release version: '#{r.version}', crystax_version: #{r.crystax_version}, sha256: '#{r.shasum}'" }
      replaced = true
    end
  end
  lines
end

def get_lastest_utility_release(formula)
  a = File.foreach(formula).select{|l| l =~ /release/}.last.split(' ')
  Release.new(a[2].delete("',"),  a[4].delete(","))
end


def create_archive(orig_release, release, util)
  util_dir = File.join('tmp', 'prebuilt', PLATFORM, 'crew', util)
  old = orig_release.to_s
  new = release.to_s
  FileUtils.cd(util_dir) do
    # rename to new release
    FileUtils.mv old, new if old != new
    # fix crystax_version in properties file
    propsfile = File.join(new, 'properties.json')
    props = JSON.parse(IO.read(propsfile), symbolize_names: true)
    props[:crystax_version] = release.crystax_version
    File.open(propsfile, 'w') { |f| f.puts props.to_json }
  end
  # make archive
  dir_to_archive = File.join('prebuilt', PLATFORM, 'crew', util, new)
  archive_path = File.join(UTILS_DOWNLOAD_DIR, util, "#{util}-#{release}-#{PLATFORM}.7z")
  FileUtils.mkdir_p File.dirname(archive_path)
  FileUtils.cd('tmp') do
    args = ['a', archive_path, dir_to_archive]
    Utils.run_command(File.join(ORIG_TOOLS_DIR, 'bin', '7za'), *args)
  end
  # rename new release back to old
  FileUtils.cd(util_dir) { FileUtils.mv new, old if old != new }
  # calculate and return sha256 sum
  Digest::SHA256.hexdigest(File.read(archive_path, mode: "rb"))
end

#
# create test data for utilities
#

orig_releases = {}
Crew_test::UTILS.each do |u|
  formula = File.join(ORIG_FORMULA_DIR, "#{u}.rb")
  orig_releases[u] = ur = get_lastest_utility_release(formula)
  src_dir = File.join(ORIG_NDK_DIR, 'prebuilt', PLATFORM, 'crew', "#{u}", "#{ur.to_s}")
  dst_dir = File.join('tmp', 'prebuilt', PLATFORM, 'crew', "#{u}")
  FileUtils.mkdir_p dst_dir
  FileUtils.cp_r src_dir, dst_dir
end

# create archives and formulas for curl
curl_releases = [Release.new('7.42.0', 1), Release.new('7.42.0', 3), Release.new('8.21.0', 1)].map do |r|
  r.shasum = create_archive(orig_releases['curl'], r, 'curl')
  r
end
curl_formula = File.join(ORIG_FORMULA_DIR, 'curl.rb')
File.open(File.join(DATA_DIR, 'curl-1.rb'), 'w') { |f| f.puts replace_releases(curl_formula, curl_releases.slice(0, 1)) }
File.open(File.join(DATA_DIR, 'curl-2.rb'), 'w') { |f| f.puts replace_releases(curl_formula, curl_releases.slice(0, 2)) }
File.open(File.join(DATA_DIR, 'curl-3.rb'), 'w') { |f| f.puts replace_releases(curl_formula, curl_releases) }

# create archives and formulas for p7zip
p7zip_releases = [Release.new('9.20.1', 1), Release.new('9.21.2', 1)].map do |r|
  r.shasum = create_archive(orig_releases['p7zip'], r, 'p7zip')
  r
end
p7zip_formula = File.join(ORIG_FORMULA_DIR, 'p7zip.rb')
File.open(File.join(DATA_DIR, 'p7zip-1.rb'), 'w') { |f| f.puts replace_releases(p7zip_formula, p7zip_releases.slice(0, 1)) }
File.open(File.join(DATA_DIR, 'p7zip-2.rb'), 'w') { |f| f.puts replace_releases(p7zip_formula, p7zip_releases.slice(0, 2)) }

# create archives and formulas for ruby
ruby_releases = [Release.new('2.2.2', 1), Release.new('2.2.3', 1)].map do |r|
  r.shasum = create_archive(orig_releases['ruby'], r, 'ruby')
  r
end
ruby_formula = File.join(ORIG_FORMULA_DIR, 'ruby.rb')
File.open(File.join(DATA_DIR, 'ruby-1.rb'), 'w') { |f| f.puts replace_releases(ruby_formula, ruby_releases.slice(0, 1)) }
File.open(File.join(DATA_DIR, 'ruby-2.rb'), 'w') { |f| f.puts replace_releases(ruby_formula, ruby_releases.slice(0, 2)) }
