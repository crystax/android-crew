require_relative 'spec_helper.rb'

describe "crew remove" do
  before(:each) do
    clean
  end

  context "without argument" do
    it "outputs error message" do
      crew 'remove'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires a formula argument')
    end
  end

  context "non existing name" do
    it "outputs error message" do
      crew 'remove', 'foo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: no available formula for foo')
    end
  end

  context "one installed release with dependants" do
    it "outputs error message" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew_checked 'install', 'libone:1.0.0'
      crew_checked 'install', 'libtwo:1.1.0'
      crew 'remove', 'libone'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: libone has installed dependants: libtwo')
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?('libtwo', '1.1.0', 1)).to eq(true)
    end
  end

  context "one of two installed releases without dependants" do
    it "outputs error message" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew_checked 'install', 'libtwo:1.1.0'
      crew_checked 'install', 'libtwo:2.2.0'
      crew 'remove', 'libtwo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: more than one version of libtwo installed')
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?('libtwo', '1.1.0', 1)).to eq(true)
      expect(in_cache?('libtwo', '2.2.0', 1)).to eq(true)
    end
  end

  context "one of two installed releases with dependants" do
    it "outputs info about uninstalling the specified release" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew_checked 'install', 'libtwo:1.1.0'
      crew_checked 'install', 'libtwo:2.2.0'
      crew_checked 'install', 'libthree:2.2.2'
      crew 'remove', 'libtwo:1.1.0'
      expect(result).to eq(:ok)
      expect(out.chomp).to eq('removing libtwo-1.1.0')
      expect(in_cache?('libone',   '1.0.0', 1)).to eq(true)
      expect(in_cache?('libtwo',   '2.2.0', 1)).to eq(true)
      expect(in_cache?('libthree', '2.2.2', 1)).to eq(true)
    end
  end

  context "one installed release without dependants" do
    it "outputs info about uninstalling release" do
      copy_formulas 'libone.rb'
      crew_checked 'install', 'libone:1.0.0'
      crew 'remove', 'libone'
      expect(result).to eq(:ok)
      expect(out).to eq("removing libone-1.0.0\n")
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
    end
  end

  context "all of the two installed releases without dependants" do
    it "outputs info about uninstalling releases" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew_checked 'install', 'libone:1.0.0'
      crew_checked 'install', 'libtwo:1.1.0'
      crew_checked 'install', 'libtwo:2.2.0'
      crew 'remove', 'libtwo:all'
      expect(result).to eq(:ok)
      expect(out.split("\n").sort).to eq(["removing libtwo-1.1.0",
                                          "removing libtwo-2.2.0"])
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?('libtwo', '1.1.0', 1)).to eq(true)
      expect(in_cache?('libtwo', '2.2.0', 1)).to eq(true)
    end
  end

  context "all installed releases with dependants" do
    it "outputs error message" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew_checked 'install', 'libone:1.0.0'
      crew_checked 'install', 'libtwo:1.1.0'
      crew_checked 'install', 'libtwo:2.2.0'
      crew_checked 'install', 'libthree:3.3.3'
      crew 'remove', 'libtwo:all'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: libtwo has installed dependants: libthree')
      expect(in_cache?('libone',   '1.0.0', 1)).to eq(true)
      expect(in_cache?('libtwo',   '1.1.0', 1)).to eq(true)
      expect(in_cache?('libtwo',   '2.2.0', 1)).to eq(true)
      expect(in_cache?('libthree', '3.3.3', 1)).to eq(true)
    end
  end
end
