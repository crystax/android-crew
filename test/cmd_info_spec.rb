require_relative 'spec_helper.rb'

describe "crew info" do
  context "without argument" do
    it "outputs error message" do
      clean
      crew 'info'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires a formula argument')
    end
  end

  context "non existing name" do
    it "outputs error message" do
      clean
      crew 'info', 'foo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: no available formula for foo')
    end
  end

  context "formula with one release and no dependencies, not installed" do
    it "outputs info about one not installed release with no dependencies" do
      clean
      copy_formulas 'libone.rb'
      crew 'info', 'libone'
      expect(out).to eq("libone: http://www.libone.org\n" \
                        "releases:\n"                     \
                        "  1.0.0  \n"                     \
                        "dependencies:\n")
      expect(exitstatus).to be_zero
    end
  end

  context "formula with two releases and one dependency, none installed" do
    it "outputs info about two releases and one dependency" do
      clean
      copy_formulas 'libtwo.rb'
      crew 'info', 'libtwo'
      expect(out).to eq("libtwo: http://www.libtwo.org\n" \
                        "releases:\n"                     \
                        "  1.1.0  \n"                     \
                        "  2.2.0  \n"                     \
                        "dependencies:\n"                 \
                        "  libone\n")
      expect(exitstatus).to be_zero
    end
  end

  context "formula with three releases and two dependencies, none installed" do
    it "outputs info about three releases and two dependencies" do
      clean
      copy_formulas 'libthree.rb'
      crew 'info', 'libthree'
      expect(out).to eq("libthree: http://www.libthree.org\n" \
                        "releases:\n"                         \
                        "  1.1.1  \n"                         \
                        "  2.2.2  \n"                         \
                        "  3.3.3  \n"                         \
                        "dependencies:\n"                     \
                        "  libone\n"                          \
                        "  libtwo\n")
      expect(exitstatus).to be_zero
    end
  end

  context "formula with three releases and two dependencies, both dependencies installed" do
    it "outputs info about two releases and one dependency" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      crew 'info', 'libthree'
      expect(out).to eq("libthree: http://www.libthree.org\n" \
                        "releases:\n"                         \
                        "  1.1.1  \n"                         \
                        "  2.2.2  \n"                         \
                        "  3.3.3  \n"                         \
                        "dependencies:\n"                     \
                        "  libone (*)\n"                      \
                        "  libtwo (*)\n")
      expect(exitstatus).to be_zero
    end
  end
end
