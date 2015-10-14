require_relative 'spec_helper.rb'
require_relative '../library/global.rb'
require_relative '../library/cmd/help.rb'

describe "simple crew commands" do
  before(:all) do
    ndk_init
    repository_init
    repository_clone
  end

  context "crew" do
    it "outputs help info" do
      crew '-b'
      expect(result).to eq(:ok)
      expect(out).to eq(CREW_HELP)
    end
  end

  context "crew help" do
    it "outputs help info" do
      crew 'help'
      expect(result).to eq(:ok)
      expect(out).to eq(CREW_HELP)
    end
  end

  context "crew version" do
    context "with argument" do
      it "outputs error message" do
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

  context "crew env" do
    it "outputs crew's working qenvironment" do
      crew 'env'
      expect(result).to eq(:ok)
      expect(out).to eq("DOWNLOAD_BASE: #{Global::DOWNLOAD_BASE}\n" \
                        "BASE_DIR:      #{Global::BASE_DIR}\n"      \
                        "NDK_DIR:       #{Global::NDK_DIR}\n"       \
                        "TOOLS_DIR:     #{Global::TOOLS_DIR}\n")
    end
  end
end
