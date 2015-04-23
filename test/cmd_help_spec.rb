require_relative 'spec_helper.rb'
require_relative '../library/cmd/help.rb'

describe "crew help" do
  it "outputs help info" do
    crew 'help'
    expect(result).to eq(:ok)
    expect(out).to eq(CREW_HELP)
  end
end
