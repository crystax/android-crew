require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew upgrade" do
  before(:all) do
    ndk_init
  end

  before(:each) do
    clean_cache
    clean_hold
    clean_engine
    repository_init
    repository_clone
  end

  context "with argument" do
    it "outputs error message" do
      crew 'upgrade', 'baz'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires no arguments')
    end
  end

  context "when there are no formulas and no changes" do
    it "outputs nothing" do
      crew_checked 'update'
      crew '-b', 'upgrade'
      expect(result).to eq(:ok)
      expect(out).to eq('')
    end
  end

  context "when there are changes only in libraries" do

    context "when there is one new release in one formula" do
      it "says about installing new release" do
        repository_add_formula :library, 'libone.rb', 'libtwo-1.rb:libtwo.rb'
        repository_clone
        crew_checked 'install', 'libone'
        crew_checked 'install', 'libtwo'
        repository_add_formula :library, 'libtwo.rb'
        crew_checked 'update'
        crew 'upgrade'
        expect(result).to eq(:ok)
        expect(out).to eq("Will install: libtwo:2.2.0:1\n"                                           \
                          "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/libtwo-2.2.0_1.7z\n" \
                          "checking integrity of the archive file libtwo-2.2.0_1.7z\n"               \
                          "unpacking archive\n")
      end
    end

    context "when there are two formulas with new release in each" do
      it "says about installing new releases" do
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
                          "checking integrity of the archive file libthree-3.3.3_1.7z\n"                 \
                          "unpacking archive\n"                                                          \
                          "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/libtwo-2.2.0_1.7z\n"     \
                          "checking integrity of the archive file libtwo-2.2.0_1.7z\n"                   \
                          "unpacking archive\n")
      end
    end
  end

  context "when there are changes only in utilities" do

    context "when there is one new release for curl utility, with crystax_version changed" do
      it "says about installing new release" do
        repository_clone
        repository_add_formula :utility, 'curl-2.rb:curl.rb'
        crew_checked 'update'
        crew '-b', 'upgrade'
        ver = "7.42.0"
        cxver = 3
        file = "curl-#{ver}_#{cxver}-#{Global::PLATFORM}.7z"
        expect(result).to eq(:ok)
        expect(out).to eq("Will install: curl:#{ver}:#{cxver}\n"                          \
                          "downloading #{Global::DOWNLOAD_BASE}/utilities/curl/#{file}\n" \
                          "checking integrity of the archive file #{file}\n"              \
                          "unpacking archive\n")
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/#{ver}_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/#{ver}_#{cxver}")).to eq(true)
        expect(Global.active_util_version('curl')).to eq("#{ver}_#{cxver}")
        expect(in_cache?(:utility, 'curl', ver, cxver)).to eq(true)
      end
    end

    context "when there are two new releases for curl utility, one with crystax_version changed, and one with upstream version changed" do
      it "says about installing new release (with new upstream)" do
        repository_clone
        repository_add_formula :utility, 'curl-3.rb:curl.rb'
        crew_checked 'update'
        crew '-b', 'upgrade'
        ver = "8.21.0"
        cxver = 1
        file = "curl-#{ver}_#{cxver}-#{Global::PLATFORM}.7z"
        expect(result).to eq(:ok)
        expect(out).to eq("Will install: curl:#{ver}:#{cxver}\n"                          \
                          "downloading #{Global::DOWNLOAD_BASE}/utilities/curl/#{file}\n" \
                          "checking integrity of the archive file #{file}\n"              \
                          "unpacking archive\n")
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/7.42.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/#{ver}_#{cxver}")).to eq(true)
        expect(Global.active_util_version('curl')).to eq("#{ver}_#{cxver}")
        expect(in_cache?(:utility, 'curl', ver, cxver)).to eq(true)
      end
    end

    context "when there are new releases for all utilities" do
      it "says about installing new releases" do
        repository_clone
        repository_add_formula :utility, 'curl-3.rb:curl.rb', 'p7zip-2.rb:p7zip.rb', 'ruby-2.rb:ruby.rb'
        crew_checked 'update'
        crew '-b', 'upgrade'
        curl_ver = "8.21.0"
        curl_cxver = 1
        curl_file = "curl-#{curl_ver}_#{curl_cxver}-#{Global::PLATFORM}.7z"
        p7zip_ver = "9.21.2"
        p7zip_cxver = 1
        p7zip_file = "p7zip-#{p7zip_ver}_#{p7zip_cxver}-#{Global::PLATFORM}.7z"
        ruby_ver = "2.2.3"
        ruby_cxver = 1
        ruby_file = "ruby-#{ruby_ver}_#{ruby_cxver}-#{Global::PLATFORM}.7z"
        expect(result).to eq(:ok)
        expect(out).to eq(
                         "Will install: curl:#{curl_ver}:#{curl_cxver}, p7zip:#{p7zip_ver}:#{p7zip_cxver}, ruby:#{ruby_ver}:#{ruby_cxver}\n" \
                         "downloading #{Global::DOWNLOAD_BASE}/utilities/curl/#{curl_file}\n"   \
                         "checking integrity of the archive file #{curl_file}\n"                \
                         "unpacking archive\n"                                                  \
                         "downloading #{Global::DOWNLOAD_BASE}/utilities/p7zip/#{p7zip_file}\n" \
                         "checking integrity of the archive file #{p7zip_file}\n"               \
                         "unpacking archive\n"                                                  \
                         "downloading #{Global::DOWNLOAD_BASE}/utilities/ruby/#{ruby_file}\n"   \
                         "checking integrity of the archive file #{ruby_file}\n"                \
                         "unpacking archive\n")
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/7.42.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/8.21.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/p7zip/9.20.1_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/p7zip/9.21.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/ruby/2.2.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/ruby/2.2.3_1")).to eq(true)
        expect(in_cache?(:utility, 'curl',  '8.21.0', 1)).to eq(true)
        expect(in_cache?(:utility, 'p7zip', '9.21.2', 1)).to eq(true)
        expect(in_cache?(:utility, 'ruby',  '2.2.3',  1)).to eq(true)
      end
    end
  end
end
