require_relative 'spec_helper.rb'
require_relative '../library/cmd/help.rb'

describe "crew" do
  it "outputs help info" do
    crew '-b'
    expect(result).to eq(:ok)
    expect(out).to eq(CREW_HELP)
  end
end
