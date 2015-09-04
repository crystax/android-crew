require 'fileutils'
require 'rspec'
require 'socket'
require 'webrick'


PORT = 9999

download_base = "http://localhost:#{PORT}/packages"
www_dir =  'www'
docroot_dir = File.join(www_dir, 'docroot')
log_dir = File.join(www_dir, 'log')
base_dir = 'crew'
ndk_dir = 'ndk'
data_dir = 'data'

FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)

server = WEBrick::HTTPServer.new :Port => PORT,
                                 :DocumentRoot => docroot_dir,
                                 :Logger => WEBrick::Log.new(File.join(www_dir, 'log', 'webrick.log')),
                                 :AccessLog => [[File.open(File.join(www_dir, 'log', 'access.log'),'w'),
                                                 WEBrick::AccessLog::COMBINED_LOG_FORMAT]]

Thread.start { server.start }

FileUtils.remove_dir(base_dir, true)
FileUtils.remove_dir(ndk_dir, true)

FileUtils.mkdir_p(File.join(ndk_dir, 'sources'))
FileUtils.mkdir_p(File.join(base_dir, 'formula', 'utilities'))
FileUtils.mkdir_p(File.join(base_dir, 'cache'))

ENV['CREW_DOWNLOAD_BASE'] = download_base
ENV['CREW_BASE_DIR'] = base_dir
ENV['CREW_NDK_DIR'] = ndk_dir

# global.rb requires evn vars to be set so we put it here
require_relative '../library/global.rb'
# helpers.rb uses constants from 'global.rb'
require_relative 'helpers.rb'


RSpec.configure do |config|
  config.include Spec::Helpers
end
