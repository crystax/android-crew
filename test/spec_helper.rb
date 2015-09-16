require 'fileutils'
require 'rspec'
require 'socket'
require 'webrick'
require 'pathname'
require_relative 'test_consts.rb'


log_dir = File.join(Crew_test::WWW_DIR, 'log')
base_dir = 'crew'

FileUtils.mkdir(log_dir) unless Dir.exist?(log_dir)

server = WEBrick::HTTPServer.new :Port => Crew_test::PORT,
                                 :DocumentRoot => Crew_test::DOCROOT_DIR,
                                 :Logger => WEBrick::Log.new(File.join(log_dir, 'webrick.log')),
                                 :AccessLog => [[File.open(File.join(log_dir, 'access.log'),'w'),
                                                 WEBrick::AccessLog::COMBINED_LOG_FORMAT]]

Thread.start { server.start }

FileUtils.remove_dir(base_dir, true)

FileUtils.mkdir_p(File.join(Crew_test::NDK_DIR, 'sources'))
FileUtils.mkdir_p(File.join(base_dir, 'formula', 'utilities'))
FileUtils.mkdir_p(File.join(base_dir, 'cache'))

ENV['CREW_DOWNLOAD_BASE'] = Crew_test::DOWNLOAD_BASE
ENV['CREW_BASE_DIR'] = base_dir
ENV['CREW_NDK_DIR'] = Crew_test::NDK_DIR

# global.rb requires evn vars to be set so we put it here
require_relative '../library/global.rb'
# helpers.rb uses constants from 'global.rb'
require_relative 'helpers.rb'


RSpec.configure do |config|
  config.include Spec::Helpers
end
