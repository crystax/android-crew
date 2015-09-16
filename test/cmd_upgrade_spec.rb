require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew upgrade" do
  context "with argument" do
    it "outputs error message" do
      clean
      crew 'upgrade', 'baz'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires no arguments')
    end
  end

  context "when there are no formulas and no changes" do
    it "outputs nothing" do
      repository_init
      repository_clone
      crew 'update'
      crew 'upgrade'
      expect(result).to eq(:ok)
      expect(out).to eq('')
    end
  end

  context "when there is one new release in one formula" do
    it "says about installing new release" do
      repository_init
      repository_add_formula :library, 'libone.rb', 'libtwo-1.rb:libtwo.rb'
      repository_clone
      crew_checked 'install', 'libone'
      crew_checked 'install', 'libtwo'
      repository_add_formula :library, 'libtwo.rb'
      crew_checked 'update'
      crew 'upgrade'
      expect(result).to eq(:ok)
      expect(out).to eq("Will install: libtwo:2.2.0:1\n"                                  \
                        "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/libtwo-2.2.0_1.7z\n" \
                        "checking integrity of the archive file libtwo-2.2.0_1.7z\n"   \
                        "unpacking archive\n")
    end
  end

  context "when there are two formulas with new release in each" do
    it "says about installing new releases" do
      repository_init
      repository_add_formula :library, 'libone.rb', 'libtwo-1.rb:libtwo.rb', 'libthree-2.rb:libthree.rb'
      repository_clone
      crew_checked 'install', 'libone'
      crew_checked 'install', 'libtwo'
      crew_checked 'install', 'libthree:1.1.1'
      repository_add_formula :library, 'libtwo.rb', 'libthree.rb'
      crew_checked 'update'
      crew 'upgrade'
      expect(result).to eq(:ok)
      expect(out).to eq("Will install: libthree:3.3.3:1, libtwo:2.2.0:1\n"                             \
                        "downloading #{Global::DOWNLOAD_BASE}/packages/libthree/libthree-3.3.3_1.7z\n" \
                        "checking integrity of the archive file libthree-3.3.3_1.7z\n"              \
                        "unpacking archive\n"                                                          \
                        "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/libtwo-2.2.0_1.7z\n"     \
                        "checking integrity of the archive file libtwo-2.2.0_1.7z\n"                \
                        "unpacking archive\n")
    end
  end

  context "when there is one new release in curl utility, with crystax_version changed" do
    it "says about installing new release" do
      repository_init
      repository_clone
      repository_add_formula :utility, 'curl-2.rb:curl.rb'
      crew_checked 'update'
      crew 'upgrade'
      expect(result).to eq(:ok)
      expect(out).to eq("Will install: curl:7.43.0:1\n"                                          \
                        "downloading #{Global::DOWNLOAD_BASE}/utilities/curl/curl_7.43.0_1.7z\n" \
                        "checking integrity of the archive file curl_7.43.0_1.7z\n"           \
                        "unpacking archive\n")
    end
  end
end
