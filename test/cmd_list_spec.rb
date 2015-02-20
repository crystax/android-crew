require_relative 'spec_helper.rb'

describe "crew list" do
  context "with argument" do
    it "outputs error message" do
      crew 'list', 'boost'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('This command requires no arguments')
    end
  end

  context "no formulas and empty hold" do
    it "outputs nothing" do
      crew 'list'
      expect(out).to eq('')
      expect(exitstatus).to be_zero
    end
  end

  context "empty hold, one formula with one release" do
    it "outputs info about one not installed releases" do
      clean_hold
      clean_formulary
      copy_formulas 'libone.rb'
      crew 'list'
      expect(out).to eq("   libone 1.0.0\n")
      expect(exitstatus).to be_zero
    end
  end

  context "empty hold, one formula with three releases" do
    it "outputs info about three not installed releases" do
      clean_hold
      clean_formulary
      copy_formulas 'libthree.rb'
      crew 'list'
      expect(out).to eq("   libthree 1.1.1\n" +
                        "   libthree 2.2.2\n" +
                        "   libthree 3.3.3\n")
      expect(exitstatus).to be_zero
    end
  end

  context "empty hold, three formulas with one, two and three releases" do
    it "outputs info about all available releases" do
      clean_hold
      clean_formulary
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew 'list'
      expect(out).to eq("   libone   1.0.0\n" +
                        "   libthree 1.1.1\n" +
                        "   libthree 2.2.2\n" +
                        "   libthree 3.3.3\n" +
                        "   libtwo   1.1.0\n" +
                        "   libtwo   2.2.0\n")
      expect(exitstatus).to be_zero
    end
  end

  context "one formula with one release installed" do
    it "outputs info about one existing release and marks it as installed" do
      clean_hold
      clean_formulary
      copy_formulas 'libone.rb'
      install_release 'libone', '1.0.0'
      crew 'list'
      expect(out).to eq(" * libone 1.0.0\n")
      expect(exitstatus).to be_zero
    end
  end

  context "one formula with two releases and one release installed" do
    it "outputs info about two releases and marks one as installed" do
      clean_hold
      clean_formulary
      copy_formulas 'libtwo.rb'
      install_release 'libtwo', '2.2.0'
      crew 'list'
      expect(out).to eq("   libtwo 1.1.0\n" +
                        " * libtwo 2.2.0\n")
      expect(exitstatus).to be_zero
    end
  end

  context "one formula with three releases and two releases installed" do
    it "outputs info about three releases and marks two as installed" do
      clean_hold
      clean_formulary
      copy_formulas 'libthree.rb'
      install_release 'libthree', '1.1.1'
      install_release 'libthree', '3.3.3'
      crew 'list'
      expect(out).to eq(" * libthree 1.1.1\n" +
                        "   libthree 2.2.2\n" +
                        " * libthree 3.3.3\n")
      expect(exitstatus).to be_zero
    end
  end

  context "three formulas with one, two and three releases, one of each releases installed" do
    it "outputs info about six releases and marks three as installed" do
      clean_hold
      clean_formulary
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libthree', '1.1.1'
      crew 'list'
      expect(out).to eq(" * libone   1.0.0\n" +
                        " * libthree 1.1.1\n" +
                        "   libthree 2.2.2\n" +
                        "   libthree 3.3.3\n" +
                        " * libtwo   1.1.0\n" +
                        "   libtwo   2.2.0\n")
      expect(exitstatus).to be_zero
    end
  end
end
