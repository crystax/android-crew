require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "Test how Crew works over HTTPS" do
  before(:each) do
    clean
    repository_network_clone
  end

  context "list command" do
    it "outputs info about three formulas" do
      crew 'list'
      expect(result).to eq(:ok)
      expect(out.split("\n").sort).to eq(["   icu      54.1",
                                          "   libone   1.0.0",
                                          "   libthree 1.1.1",
                                          "   libthree 2.2.2",
                                          "   libthree 3.3.3",
                                          "   libtwo   1.1.0",
                                          "   libtwo   2.2.0"])
    end
  end

  context "update command" do
    it "says all up-to-date" do
      crew 'update'
      expect(result).to eq(:ok)
      expect(out).to eq("Already up-to-date.\n")
    end
  end

  context "install icu command" do
    it "outputs info about installing existing release" do
      olddb = Global::DOWNLOAD_BASE
      oldverbose = $VERBOSE
      $VERBOSE = nil
      Global::DOWNLOAD_BASE = ENV['CREW_DOWNLOAD_BASE'] = 'https://crew.crystax.net:9876'
      file = 'icu-54.1.7z'
      url = File.join(Global::DOWNLOAD_BASE, file)
      crew 'install', 'icu'
      Global::DOWNLOAD_BASE = ENV['CREW_DOWNLOAD_BASE'] = olddb
      $VERBOSE = oldverbose
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for icu: \n"             \
                        "  dependencies to install: [] \n"                    \
                        "downloading #{url}\n"                                \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('icu', '54.1')).to eq(true)
    end
  end
end
