require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew version" do
  context "with argument" do
    it "outputs error message" do
      clean
      crew 'version', 'bar'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires no arguments')
    end
  end

  context "without argument" do
    it "outputs version info" do
      crew 'version'
      expect(out.chomp).to eq(Global::VERSION)
      expect(exitstatus).to be_zero
    end
  end
end
