require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew cleanup" do
  before(:each) do
      clean
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
      crew 'install', 'libone' ; expect(result).to eq(:ok)
      crew 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq('')
      expect(in_cache?('libone', '1.0.0')).to eq(true)
    end
  end

  context "when one release installed and -n specified" do
    it "outputs nothing" do
      copy_formulas 'libone.rb'
      crew 'install', 'libone' ; expect(result).to eq(:ok)
      crew 'cleanup', '-n'
      expect(result).to eq(:ok)
      expect(out).to eq('')
      expect(in_cache?('libone', '1.0.0')).to eq(true)
    end
  end

  context "when two releases installed" do
    it "outputs about removing libtwo 1.1.0" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew 'install', 'libone:1.0.0' ; expect(result).to eq(:ok)
      crew 'install', 'libtwo:1.1.0' ; expect(result).to eq(:ok)
      crew 'install', 'libtwo:2.2.0' ; expect(result).to eq(:ok)
      crew 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::HOLD_DIR}/libtwo/1.1.0\n" \
                        "removing: #{Global::CACHE_DIR}/#{archive_name('libtwo', '1.1.0')}\n")
      expect(in_cache?('libone', '1.0.0')).to eq(true)
      expect(in_cache?('libtwo', '1.1.0')).to eq(false)
      expect(in_cache?('libtwo', '2.2.0')).to eq(true)
    end
  end

  context "when two releases installed and -n specified" do
    it "outputs that would remove libtwo 1.1.0" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew 'install', 'libone:1.0.0' ; expect(result).to eq(:ok)
      crew 'install', 'libtwo:1.1.0' ; expect(result).to eq(:ok)
      crew 'install', 'libtwo:2.2.0' ; expect(result).to eq(:ok)
      crew 'cleanup', '-n'
      expect(result).to eq(:ok)
      expect(out).to eq("would remove: #{Global::HOLD_DIR}/libtwo/1.1.0\n" \
                        "would remove: #{Global::CACHE_DIR}/#{archive_name('libtwo', '1.1.0')}\n")
      expect(in_cache?('libone', '1.0.0')).to eq(true)
      expect(in_cache?('libtwo', '1.1.0')).to eq(true)
      expect(in_cache?('libtwo', '2.2.0')).to eq(true)
    end
  end

  context "when of three formulas one release, two releases and three releases installed" do
    it "outputs about removing libtwo 1.1.0, libthree 1.1.1 and 2.2.2" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew 'install', 'libone:1.0.0'   ; expect(result).to eq(:ok)
      crew 'install', 'libtwo:1.1.0'   ; expect(result).to eq(:ok)
      crew 'install', 'libtwo:2.2.0'   ; expect(result).to eq(:ok)
      crew 'install', 'libthree:1.1.1' ; expect(result).to eq(:ok)
      crew 'install', 'libthree:2.2.2' ; expect(result).to eq(:ok)
      crew 'install', 'libthree:3.3.3' ; expect(result).to eq(:ok)
      crew 'cleanup'
      expect(result).to eq(:ok)
      expect(out).to eq("removing: #{Global::HOLD_DIR}/libthree/1.1.1\n"     \
                        "removing: #{Global::HOLD_DIR}/libthree/2.2.2\n"     \
                        "removing: #{Global::HOLD_DIR}/libtwo/1.1.0\n"       \
                        "removing: #{Global::CACHE_DIR}/libthree-1.1.1.7z\n" \
                        "removing: #{Global::CACHE_DIR}/libthree-2.2.2.7z\n" \
                        "removing: #{Global::CACHE_DIR}/libtwo-1.1.0.7z\n")
      expect(in_cache?('libone', '1.0.0')).to eq(true)
      expect(in_cache?('libtwo', '1.1.0')).to eq(false)
      expect(in_cache?('libtwo', '2.2.0')).to eq(true)
      expect(in_cache?('libthree', '1.1.1')).to eq(false)
      expect(in_cache?('libthree', '2.2.2')).to eq(false)
      expect(in_cache?('libthree', '3.3.3')).to eq(true)
    end
  end
end
