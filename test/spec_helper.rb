require 'fileutils'
require 'rspec'


download_base = 'http://ithilien:8000'
base_dir = './crew'
ndk_dir = './ndk'

FileUtils.remove_dir(base_dir, true)
FileUtils.remove_dir(ndk_dir, true)

FileUtils.mkdir_p(File.join(ndk_dir, 'sources'))
FileUtils.mkdir_p(File.join(base_dir, 'formula'))
FileUtils.mkdir_p(File.join(base_dir, 'cache'))


ENV['CREW_DOWNLOAD_BASE'] = download_base
ENV['CREW_BASE_DIR'] = base_dir
ENV['CREW_NDK_DIR'] = ndk_dir


# helpers.rb requires evn vars to be set becase it requires 'globals.rb'
require_relative 'helpers.rb'


RSpec.configure do |config|
  config.include Spec::Helpers
end
