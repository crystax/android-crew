require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "Test how Crew works over HTTPS" do
  before(:all) do
    ndk_init
  end

  before(:each) do
    clean_hold
    clean_cache
    clean_engine
    repository_network_init
    repository_network_clone
  end

  context "when list command issued" do
    it "outputs info about only about utilities" do
      crew 'list'
      expect(result).to eq(:ok)
        expect(out.split("\n")).to eq(["Utilities:",
                                       " * curl   7.42.0  1",
                                       " * p7zip  9.20.1  1",
                                       " * ruby   2.2.2   1",
                                       "Libraries:"])
    end
  end

  # context "update command" do
  #   it "says all up-to-date" do
  #     crew 'update'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("Already up-to-date.\n")
  #   end
  # end

  # context "install icu command" do
  #   it "outputs info about installing existing release" do
  #     olddb = Global::DOWNLOAD_BASE
  #     oldverbose = $VERBOSE
  #     $VERBOSE = nil
  #     Global::DOWNLOAD_BASE = ENV['CREW_DOWNLOAD_BASE'] = 'https://crew.crystax.net:9876'
  #     file = 'icu-54.1.7z'
  #     url = File.join(Global::DOWNLOAD_BASE, file)
  #     crew 'install', 'icu'
  #     Global::DOWNLOAD_BASE = ENV['CREW_DOWNLOAD_BASE'] = olddb
  #     $VERBOSE = oldverbose
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for icu: \n"             \
  #                       "  dependencies to install: [] \n"                    \
  #                       "downloading #{url}\n"                                \
  #                       "checking integrity of the archive file #{file}\n" \
  #                       "unpacking archive\n")
  #     expect(in_cache?(:library, 'icu', '54.1')).to eq(true)
  #   end
  # end
end
