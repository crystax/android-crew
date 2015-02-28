require_relative 'spec_helper.rb'

describe "crew remove" do
  context "without argument" do
    it "outputs error message" do
      clean
      crew 'remove'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires a formula argument')
    end
  end

  context "non existing name" do
    it "outputs error message" do
      clean
      crew 'remove', 'foo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: foo not installed')
    end
  end

  context "one installed release with dependants" do
    it "outputs error message" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      crew 'remove', 'libone'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: libone has installed dependants: ["libtwo"]')
    end
  end

  context "one of two installed releases without dependants" do
    it "outputs error message" do
      clean
      copy_formulas 'libtwo.rb'
      install_release 'libtwo', '1.1.0'
      install_release 'libtwo', '2.2.0'
      crew 'remove', 'libtwo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: more than one version of libtwo installed')
    end
  end

  context "one of two installed releases with dependants" do
    it "outputs error message" do
      clean
      copy_formulas 'libtwo.rb', 'libthree.rb'
      install_release 'libtwo', '1.1.0'
      install_release 'libtwo', '2.2.0'
      install_release 'libthree', '2.2.0'
      crew 'remove', 'libtwo:1.1.0'
      expect(exitstatus).to be_zero
      expect(out.chomp).to eq('uninstalling libtwo-1.1.0')
    end
  end

  context "one installed release without dependants" do
    it "outputs info about uninstalling release" do
      clean
      copy_formulas 'libone.rb'
      install_release 'libone', '1.0.0'
      crew 'remove', 'libone'
      expect(exitstatus).to be_zero
      expect(out).to eq("uninstalling libone-1.0.0\n")
    end
  end

  context "all of the two installed releases without dependants" do
    it "outputs info about uninstalling releases" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libtwo', '2.2.0'
      crew 'remove', 'libtwo:all'
      expect(exitstatus).to be_zero
      expect(out).to eq("uninstalling libtwo-1.1.0\nuninstalling libtwo-2.2.0\n")
    end
  end
end
