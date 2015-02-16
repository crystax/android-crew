require_relative 'spec_helper.rb'
require_relative '../library/cmd/help.rb'

describe "crew" do
  it "outputs help info" do
    crew
    expect(out).to eq(CREW_HELP)
    expect(exitstatus).to be_zero
  end
end
