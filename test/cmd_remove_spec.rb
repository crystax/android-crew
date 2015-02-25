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

  # context "installed release with no dependants" do
  #   it "outputs info about uninstalling release" do
  #     clean
  #     copy_formulas 'libone.rb'
  #     install_release 'libone', '1.0.0'
  #     crew 'remove', 'libone'
  #     expect(exitstatus).to be_zero
  #     expect(out).to eq("uninstalling libone-1.0.0\n")
  #   end
  # end
end
