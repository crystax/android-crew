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
        expect(out).to eq("Will install: libtwo:2.2.0:1\n"                                                            \
                          "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/libtwo-2.2.0_1.#{Global::ARCH_EXT}\n" \
                          "checking integrity of the archive file libtwo-2.2.0_1.#{Global::ARCH_EXT}\n"               \
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
                          "downloading #{Global::DOWNLOAD_BASE}/packages/libthree/libthree-3.3.3_1.#{Global::ARCH_EXT}\n" \
                          "checking integrity of the archive file libthree-3.3.3_1.#{Global::ARCH_EXT}\n"                 \
                          "unpacking archive\n"                                                          \
                          "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/libtwo-2.2.0_1.#{Global::ARCH_EXT}\n"     \
                          "checking integrity of the archive file libtwo-2.2.0_1.#{Global::ARCH_EXT}\n"                   \
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
        file = "curl-#{ver}_#{cxver}-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
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
        file = "curl-#{ver}_#{cxver}-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
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
        repository_add_formula :utility, 'curl-3.rb:curl.rb', 'libarchive-2.rb:libarchive.rb', 'ruby-2.rb:ruby.rb', 'xz-2.rb:xz.rb'
        crew_checked 'update'
        crew '-b', 'upgrade'
        curl_file = "curl-8.21.0_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        libarchive_file = "libarchive-3.1.3_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        ruby_file = "ruby-2.2.3_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        xz_file = "xz-5.2.3_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        expect(result).to eq(:ok)
        expect(out).to eq(
                         "Will install: curl:8.21.0:1, libarchive:3.1.3:1, ruby:2.2.3:1, xz:5.2.3:1\n"    \
                         "downloading #{Global::DOWNLOAD_BASE}/utilities/curl/#{curl_file}\n"             \
                         "checking integrity of the archive file #{curl_file}\n"                          \
                         "unpacking archive\n"                                                            \
                         "downloading #{Global::DOWNLOAD_BASE}/utilities/libarchive/#{libarchive_file}\n" \
                         "checking integrity of the archive file #{libarchive_file}\n"                    \
                         "unpacking archive\n"                                                            \
                         "downloading #{Global::DOWNLOAD_BASE}/utilities/ruby/#{ruby_file}\n"             \
                         "checking integrity of the archive file #{ruby_file}\n"                          \
                         "unpacking archive\n"                                                            \
                         "downloading #{Global::DOWNLOAD_BASE}/utilities/xz/#{xz_file}\n"                 \
                         "checking integrity of the archive file #{xz_file}\n"                            \
                         "unpacking archive\n")
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/7.42.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/8.21.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/libarchive/3.1.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/libarchive/3.1.3_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/ruby/2.2.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/ruby/2.2.3_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/xz/5.2.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/xz/5.2.3_1")).to eq(true)
        expect(in_cache?(:utility, 'curl',       '8.21.0', 1)).to eq(true)
        expect(in_cache?(:utility, 'libarchive', '3.1.3',  1)).to eq(true)
        expect(in_cache?(:utility, 'ruby',       '2.2.3',  1)).to eq(true)
        expect(in_cache?(:utility, 'xz',         '5.2.3',  1)).to eq(true)
      end
    end
  end

  context "when there are changes in libraries and utilities" do

    context "when there is one new release in one formula and one new release for curl utility" do
      it "says about installing new releases" do
        repository_add_formula :library, 'libone.rb', 'libtwo-1.rb:libtwo.rb'
        repository_clone
        crew_checked 'install', 'libone'
        crew_checked 'install', 'libtwo'
        repository_add_formula :library, 'libtwo.rb'
        repository_add_formula :utility, 'curl-2.rb:curl.rb'
        crew_checked 'update'
        crew 'upgrade'
        curlfile = "curl-7.42.0_3-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        libtwofile = "libtwo-2.2.0_1.#{Global::ARCH_EXT}"
        expect(result).to eq(:ok)
        expect(out.split("\n")).to eq(["Will install: curl:7.42.0:3",
                                       "downloading #{Global::DOWNLOAD_BASE}/utilities/curl/#{curlfile}",
                                       "checking integrity of the archive file #{curlfile}",
                                       "unpacking archive",
                                       "Will install: libtwo:2.2.0:1",
                                       "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/#{libtwofile}",
                                       "checking integrity of the archive file #{libtwofile}",
                                       "unpacking archive"
                                      ])
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/7.42.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/7.42.0_3")).to eq(true)
        expect(Global.active_util_version('curl')).to eq("7.42.0_3")
        expect(in_cache?(:utility, 'curl', '7.42.0', 3)).to eq(true)
      end
    end

    context "when there are two formulas with new release in each and there are new releases for all utilities" do
      it "says about installing new releases" do
        repository_add_formula :library, 'libone.rb', 'libtwo-1.rb:libtwo.rb', 'libthree-2.rb:libthree.rb'
        repository_clone
        crew_checked 'install', 'libone'
        crew_checked 'install', 'libtwo'
        crew_checked 'install', 'libthree:1.1.1'
        repository_add_formula :library, 'libtwo.rb', 'libthree.rb'
        repository_add_formula :utility, 'curl-3.rb:curl.rb', 'libarchive-2.rb:libarchive.rb', 'ruby-2.rb:ruby.rb', 'xz-2.rb:xz.rb'
        crew_checked 'update'
        crew 'upgrade'
        lib3file = "libthree-3.3.3_1.#{Global::ARCH_EXT}"
        lib2file = "libtwo-2.2.0_1.#{Global::ARCH_EXT}"
        curlfile = "curl-8.21.0_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        libarchivefile = "libarchive-3.1.3_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        rubyfile = "ruby-2.2.3_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        xzfile = "xz-5.2.3_1-#{Global::PLATFORM}.#{Global::ARCH_EXT}"
        expect(result).to eq(:ok)
        expect(out.split("\n")).to eq(["Will install: curl:8.21.0:1, libarchive:3.1.3:1, ruby:2.2.3:1, xz:5.2.3:1",
                                       "downloading #{Global::DOWNLOAD_BASE}/utilities/curl/#{curlfile}",
                                       "checking integrity of the archive file #{curlfile}",
                                       "unpacking archive",
                                       "downloading #{Global::DOWNLOAD_BASE}/utilities/libarchive/#{libarchivefile}",
                                       "checking integrity of the archive file #{libarchivefile}",
                                       "unpacking archive",
                                       "downloading #{Global::DOWNLOAD_BASE}/utilities/ruby/#{rubyfile}",
                                       "checking integrity of the archive file #{rubyfile}",
                                       "unpacking archive",
                                       "downloading #{Global::DOWNLOAD_BASE}/utilities/xz/#{xzfile}",
                                       "checking integrity of the archive file #{xzfile}",
                                       "unpacking archive",
                                       "Will install: libthree:3.3.3:1, libtwo:2.2.0:1",
                                       "downloading #{Global::DOWNLOAD_BASE}/packages/libthree/#{lib3file}",
                                       "checking integrity of the archive file #{lib3file}",
                                       "unpacking archive",
                                       "downloading #{Global::DOWNLOAD_BASE}/packages/libtwo/#{lib2file}",
                                       "checking integrity of the archive file #{lib2file}",
                                       "unpacking archive"
                                      ])
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/7.42.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/curl/8.21.0_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/libarchive/3.1.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/libarchive/3.1.3_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/ruby/2.2.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/ruby/2.2.3_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/xz/5.2.2_1")).to eq(true)
        expect(Dir.exists?("#{Global::ENGINE_DIR}/xz/5.2.3_1")).to eq(true)
        expect(in_cache?(:utility, 'curl',       '8.21.0', 1)).to eq(true)
        expect(in_cache?(:utility, 'libarchive', '3.1.3',  1)).to eq(true)
        expect(in_cache?(:utility, 'ruby',       '2.2.3',  1)).to eq(true)
        expect(in_cache?(:utility, 'xz',         '5.2.3',  1)).to eq(true)
      end
    end
  end
end
