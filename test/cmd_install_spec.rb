require_relative 'spec_helper.rb'

describe "crew install" do
  context "without argument" do
    it "outputs error message" do
      clean
      crew 'install'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires a formula argument')
    end
  end

  context "non existing name" do
    it "outputs error message" do
      clean
      crew 'install', 'foo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: no available formula for foo')
    end
  end

  # context "existing formula with one release" do
  #   it "outputs info about installing existing release" do
  #     clean
  #     crew 'install', 'libone'
  #     expect(exitstatus).to be_zero
  #     expect(out).to eq('')
  #   end
  # end
end
