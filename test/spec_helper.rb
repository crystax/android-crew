require 'fileutils'
require 'rspec'
require 'socket'
require 'webrick'


PORT = 9999

download_base = "http://#{Socket.gethostbyname(Socket.gethostname).first}:#{PORT}"
www_dir =  './www'
docroot_dir = "#{www_dir}/docroot"
log_dir = "#{www_dir}/log"
base_dir = './crew'
ndk_dir = './ndk'
data_dir = './data'

FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)

server = WEBrick::HTTPServer.new :Port => PORT,
                                 :DocumentRoot => docroot_dir,
                                 :Logger => WEBrick::Log.new("#{www_dir}/log/webrick.log"),
                                 :AccessLog => [[File.open("#{www_dir}/log/access.log",'w'),
                                                 WEBrick::AccessLog::COMBINED_LOG_FORMAT]]

Thread.start { server.start }

FileUtils.remove_dir(base_dir, true)
FileUtils.remove_dir(ndk_dir, true)

FileUtils.mkdir_p(File.join(ndk_dir, 'sources'))
FileUtils.mkdir_p(File.join(base_dir, 'formula'))
FileUtils.mkdir_p(File.join(base_dir, 'cache'))


ENV['CREW_DOWNLOAD_BASE'] = download_base
ENV['CREW_BASE_DIR'] = base_dir
ENV['CREW_NDK_DIR'] = ndk_dir


# helpers.rb requires evn vars to be set becase it requires 'global.rb'
require_relative 'helpers.rb'


RSpec.configure do |config|
  config.include Spec::Helpers
end
