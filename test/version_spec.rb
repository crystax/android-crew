require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew version" do
  it "outputs version info" do
    crew 'version'
    expect(out.chomp).to eq(Global::VERSION)
    expect(exitstatus).to be_zero
  end
end
