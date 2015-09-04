require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew env" do
  it "outputs crew's working qenvironment" do
    crew 'env'
    expect(result).to eq(:ok)
    expect(out).to eq("DOWNLOAD_BASE: #{Global::DOWNLOAD_BASE}\n" \
                      "BASE_DIR:      #{Global::BASE_DIR}\n" \
                      "NDK_DIR:       #{Global::NDK_DIR}\n" \
                      "TOOLS_DIR:     #{Global::TOOLS_DIR}\n")
  end
end
