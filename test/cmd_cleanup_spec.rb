require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew cleanup" do
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

  context "with wrong argument" do
    it "outputs error message" do
      crew 'cleanup', 'bar'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command accepts only one optional argument: -n')
    end
  end

  context "when there are no formulas and nothing installed" do
    it "outputs nothing" do
      crew 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq('')
    end
  end

  context "when one release installed" do
    it "outputs nothing" do
      copy_formulas 'libone.rb'
      crew_checked 'install', 'libone'
      crew 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq('')
      expect(in_cache?(:library, 'libone', '1.0.0', 1)).to eq(true)
    end
  end

  context "when one release installed and -n specified" do
    it "outputs nothing" do
      copy_formulas 'libone.rb'
      crew_checked 'install', 'libone'
      crew 'cleanup', '-n'
      expect(result).to eq(:ok)
      expect(out).to eq('')
      expect(in_cache?(:library, 'libone', '1.0.0', 1)).to eq(true)
    end
  end

  context "when two releases installed" do
    it "outputs about removing libtwo 1.1.0" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew_checked 'install', 'libone:1.0.0'
      crew_checked 'install', 'libtwo:1.1.0'
      crew_checked 'install', 'libtwo:2.2.0'
      crew '-b', 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::HOLD_DIR}/libtwo/1.1.0\n" \
                        "removing: #{Global::CACHE_DIR}/#{archive_name(:library, 'libtwo', '1.1.0', 1)}\n")
      expect(in_cache?(:library, 'libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?(:library, 'libtwo', '1.1.0', 1)).to eq(false)
      expect(in_cache?(:library, 'libtwo', '2.2.0', 1)).to eq(true)
    end
  end

  context "when two releases installed and -n specified" do
    it "outputs that would remove libtwo 1.1.0" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew_checked 'install', 'libone:1.0.0'
      crew_checked 'install', 'libtwo:1.1.0'
      crew_checked 'install', 'libtwo:2.2.0'
      crew 'cleanup', '-n'
      expect(result).to eq(:ok)
      expect(out).to eq("would remove: #{Global::HOLD_DIR}/libtwo/1.1.0\n" \
                        "would remove: #{Global::CACHE_DIR}/#{archive_name(:library, 'libtwo', '1.1.0', 1)}\n")
      expect(in_cache?(:library, 'libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?(:library, 'libtwo', '1.1.0', 1)).to eq(true)
      expect(in_cache?(:library, 'libtwo', '2.2.0', 1)).to eq(true)
    end
  end

  context "when of three formulas one release, two releases and three releases installed" do
    it "outputs about removing libtwo 1.1.0, libthree 1.1.1 and 2.2.2" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew_checked 'install', 'libone:1.0.0'
      crew_checked 'install', 'libtwo:1.1.0'
      crew_checked 'install', 'libtwo:2.2.0'
      crew_checked 'install', 'libthree:1.1.1'
      crew_checked 'install', 'libthree:2.2.2'
      crew_checked 'install', 'libthree:3.3.3'
      crew 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::HOLD_DIR}/libthree/1.1.1\n"       \
                        "removing: #{Global::HOLD_DIR}/libthree/2.2.2\n"       \
                        "removing: #{Global::HOLD_DIR}/libtwo/1.1.0\n"         \
                        "removing: #{Global::CACHE_DIR}/libthree-1.1.1_1.#{Global::ARCH_EXT}\n" \
                        "removing: #{Global::CACHE_DIR}/libthree-2.2.2_1.#{Global::ARCH_EXT}\n" \
                        "removing: #{Global::CACHE_DIR}/libtwo-1.1.0_1.#{Global::ARCH_EXT}\n")
      expect(in_cache?(:library, 'libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?(:library, 'libtwo', '1.1.0', 1)).to eq(false)
      expect(in_cache?(:library, 'libtwo', '2.2.0', 1)).to eq(true)
      expect(in_cache?(:library, 'libthree', '1.1.1', 1)).to eq(false)
      expect(in_cache?(:library, 'libthree', '2.2.2', 1)).to eq(false)
      expect(in_cache?(:library, 'libthree', '3.3.3', 1)).to eq(true)
    end
  end

  context "when two releases of the curl utility are installed, releases differ in crystax_version" do
    it "outputs about removing curl 7.42.0:1" do
      repository_add_formula :utility, 'curl-2.rb:curl.rb'
      crew_checked 'update'
      crew_checked 'upgrade'
      crew '-b', 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::ENGINE_DIR}/curl/7.42.0_1\n")
      expect(in_cache?(:utility, 'curl', '7.42.0', 3)).to eq(true)
    end
  end

  context "when two releases of the curl utility are installed, releases differ in upstream version" do
    it "outputs about removing curl 7.42.0:1" do
      repository_add_formula :utility, 'curl-3.rb:curl.rb'
      crew_checked 'update'
      crew_checked 'upgrade'
      crew '-b', 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::ENGINE_DIR}/curl/7.42.0_1\n")
      expect(in_cache?(:utility, 'curl', '8.21.0', 1)).to eq(true)
    end
  end

  context "when two releases of the two utilities are installed" do
    it "says about removing two old releases" do
      repository_add_formula :utility, 'curl-3.rb:curl.rb', 'ruby-2.rb:ruby.rb'
      crew_checked 'update'
      crew_checked 'upgrade'
      crew '-b', 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::ENGINE_DIR}/curl/7.42.0_1\n" \
                        "removing: #{Global::ENGINE_DIR}/ruby/2.2.2_1\n")
      expect(in_cache?(:utility, 'curl', '8.21.0', 1)).to eq(true)
      expect(in_cache?(:utility, 'ruby', '2.2.3',  1)).to eq(true)
    end
  end

  context "when three releases of the curl utility are installed" do
    it "outputs about removing curl 7.42.0:3" do
      repository_add_formula :utility, 'curl-2.rb:curl.rb'
      crew_checked 'update'
      crew_checked 'upgrade'
      repository_add_formula :utility, 'curl-3.rb:curl.rb'
      crew_checked 'update'
      crew_checked 'upgrade'
      crew '-b', 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::ENGINE_DIR}/curl/7.42.0_1\n" \
                        "removing: #{Global::ENGINE_DIR}/curl/7.42.0_3\n" \
                        "removing: #{Global::CACHE_DIR}/curl-7.42.0_3-#{Global::PLATFORM}.#{Global::ARCH_EXT}\n")
      expect(in_cache?(:utility, 'curl', '8.21.0', 1)).to eq(true)
    end
  end

  context "when all utilities have more than one release installed" do
    it "says about removing old releases" do
      repository_clone
      repository_add_formula :utility, 'curl-2.rb:curl.rb', 'libarchive-2.rb:libarchive.rb', 'ruby-2.rb:ruby.rb', 'xz-2.rb:xz.rb'
      crew_checked 'update'
      crew_checked 'upgrade'
      repository_add_formula :utility, 'curl-3.rb:curl.rb'
      crew_checked 'update'
      crew_checked 'upgrade'
      crew 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::ENGINE_DIR}/curl/7.42.0_1\n"      \
                        "removing: #{Global::ENGINE_DIR}/curl/7.42.0_3\n"      \
                        "removing: #{Global::ENGINE_DIR}/libarchive/3.1.2_1\n" \
                        "removing: #{Global::ENGINE_DIR}/ruby/2.2.2_1\n"       \
                        "removing: #{Global::ENGINE_DIR}/xz/5.2.2_1\n"         \
                        "removing: #{Global::CACHE_DIR}/curl-7.42.0_3-#{Global::PLATFORM}.#{Global::ARCH_EXT}\n")
      expect(in_cache?(:utility, 'curl',       '8.21.0', 1)).to eq(true)
      expect(in_cache?(:utility, 'libarchive', '3.1.3',  1)).to eq(true)
      expect(in_cache?(:utility, 'ruby',       '2.2.3',  1)).to eq(true)
      expect(in_cache?(:utility, 'xz',         '5.2.3',  1)).to eq(true)
    end
  end

  # todo: cleaning utilities and libraries at the same time
end
