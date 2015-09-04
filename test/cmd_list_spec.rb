require_relative 'spec_helper.rb'

describe "crew list" do
  before(:each) do
    clean
  end

  context "with 3 incorrect arguments" do
    it "outputs error message" do
      crew 'list', 'a', 'b', 'c'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires either one or no arguments')
      expect(out).to eq('')
    end
  end

  context "with 2 incorrect arguments" do
    it "outputs error message" do
      crew 'list', 'a', 'b'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires either one or no arguments')
      expect(out).to eq('')
    end
  end

  context "with 2 correct arguments" do
    it "outputs error message" do
      crew 'list', 'utils', 'libs'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires either one or no arguments')
      expect(out).to eq('')
    end
  end

  context "with incorrect argument" do
    it "outputs error message" do
      crew 'list', 'a'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: argument must either \'libs\' or \'utils\'')
      expect(out).to eq('')
    end
  end

  context "with libs argument, no formulas and empty hold" do
    it "outputs nothing" do
      crew 'list', 'libs'
      expect(result).to eq(:ok)
      expect(out).to eq('')
    end
  end

  context "with libs argument, empty hold, one formula with one release" do
    it "outputs info about one not installed release" do
      copy_formulas 'libone.rb'
      crew 'list', 'libs'
      expect(result).to eq(:ok)
      expect(out).to eq("   libone  1.0.0  1\n")
    end
  end

  context "with libs argument, empty hold, one formula with three releases" do
    it "outputs info about three not installed releases" do
      copy_formulas 'libthree.rb'
      crew 'list', 'libs'
      expect(result).to eq(:ok)
      expect(out).to eq("   libthree  1.1.1  1\n" \
                        "   libthree  2.2.2  1\n" \
                        "   libthree  3.3.3  1\n")
    end
  end

  context "with libs argument, empty hold, three formulas with one, two and three releases" do
    it "outputs info about all available releases" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew 'list', 'libs'
      expect(result).to eq(:ok)
      expect(out.split("\n").sort).to eq(["   libone    1.0.0  1",
                                          "   libthree  1.1.1  1",
                                          "   libthree  2.2.2  1",
                                          "   libthree  3.3.3  1",
                                          "   libtwo    1.1.0  1",
                                          "   libtwo    2.2.0  1"])
    end
  end

  context "with libs argument, one formula with one release installed" do
    it "outputs info about one existing release and marks it as installed" do
      copy_formulas 'libone.rb'
      install_release 'libone', '1.0.0'
      crew 'list', 'libs'
      expect(result).to eq(:ok)
      expect(out).to eq(" * libone 1.0.0\n")
    end
  end

  context "one formula with two releases and one release installed" do
    it "outputs info about two releases and marks one as installed" do
      copy_formulas 'libtwo.rb'
      install_release 'libtwo', '2.2.0'
      crew 'list'
      expect(result).to eq(:ok)
      expect(out).to eq("   libtwo 1.1.0\n" \
                        " * libtwo 2.2.0\n")
    end
  end

  context "one formula with three releases and two releases installed" do
    it "outputs info about three releases and marks two as installed" do
      copy_formulas 'libthree.rb'
      install_release 'libthree', '1.1.1'
      install_release 'libthree', '3.3.3'
      crew 'list'
      expect(result).to eq(:ok)
      expect(out).to eq(" * libthree 1.1.1\n" \
                        "   libthree 2.2.2\n" \
                        " * libthree 3.3.3\n")
    end
  end

  context "three formulas with one, two and three releases, one of each releases installed" do
    it "outputs info about six releases and marks three as installed" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libthree', '1.1.1'
      crew 'list'
      expect(result).to eq(:ok)
      expect(out.split("\n").sort).to eq(["   libthree 2.2.2",
                                          "   libthree 3.3.3",
                                          "   libtwo   2.2.0",
                                          " * libone   1.0.0",
                                          " * libthree 1.1.1",
                                          " * libtwo   1.1.0"])
    end
  end

  context "three formulas with one, two and three releases, one of each releases installed, garbage in the hold" do
    it "outputs a warning about garbage in the hld and info about six releases and marks three as installed" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libthree', '1.1.1'
      add_garbage_into_hold 'libone'
      crew 'list'
      expect(err).to eq("warning: directory #{File.join(Global::HOLD_DIR, 'libone')} contains foreign object: garbage\n")
      expect(out.split("\n").sort).to eq(["   libthree 2.2.2",
                                          "   libthree 3.3.3",
                                          "   libtwo   2.2.0",
                                          " * libone   1.0.0",
                                          " * libthree 1.1.1",
                                          " * libtwo   1.1.0"])
      expect(exitstatus).to be_zero
    end
  end
end
