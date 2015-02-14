require_relative 'spec_helper.rb'
require_relative '../library/cmd/help.rb'

describe "crew help" do
  it "outputs help info" do
    crew 'help'
    expect(out).to eq(CREW_HELP)
    expect(exitstatus).to be_zero
  end
end
