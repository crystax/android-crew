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

  context "about ruby, all utilities with one release each" do
    it "outputs info about ruby" do
      clean
      copy_utilities
      crew '-b', 'info', 'ruby'
      expect(result).to eq(:ok)
      expect(out.split("\n")).to eq(["Name:        ruby",
                                     "Formula:     #{Global::UTILITIES_DIR}/ruby.rb",
                                     "Homepage:    https://www.ruby-lang.org/",
                                     "Description: Powerful, clean, object-oriented scripting language",
                                     "Type:        utility",
                                     "Releases:",
                                     "  2.2.2 1  installed"])
    end
  end

  context "about all crew utilities, all utilities with one release each" do
    it "outputs info about crew utilities" do
      clean
      copy_utilities
      crew 'info', 'curl', 'p7zip', 'ruby'
      expect(result).to eq(:ok)
      expect(out.split("\n")).to eq(["Name:        curl",
                                     "Formula:     #{Global::UTILITIES_DIR}/curl.rb",
                                     "Homepage:    http://curl.haxx.se/",
                                     "Description: Get a file from an HTTP, HTTPS or FTP server",
                                     "Type:        utility",
                                     "Releases:",
                                     "  7.42.0 1  installed",
                                     "",
                                     "Name:        p7zip",
                                     "Formula:     #{Global::UTILITIES_DIR}/p7zip.rb",
                                     "Homepage:    http://p7zip.sourceforge.net/",
                                     "Description: 7-Zip (high compression file archiver) implementation",
                                     "Type:        utility",
                                     "Releases:",
                                     "  9.20.1 1  installed",
                                     "",
                                     "Name:        ruby",
                                     "Formula:     #{Global::UTILITIES_DIR}/ruby.rb",
                                     "Homepage:    https://www.ruby-lang.org/",
                                     "Description: Powerful, clean, object-oriented scripting language",
                                     "Type:        utility",
                                     "Releases:",
                                     "  2.2.2 1  installed"])
    end
  end

  context "formula with one release and no dependencies, not installed" do
    it "outputs info about one not installed release with no dependencies" do
      clean
      copy_formulas 'libone.rb'
      crew 'info', 'libone'
      expect(result).to eq(:ok)
      expect(out.split("\n")).to eq(["Name:        libone",
                                     "Formula:     #{Global::FORMULA_DIR}/libone.rb",
                                     "Homepage:    http://www.libone.org",
                                     "Description: Library One",
                                     "Type:        library",
                                     "Releases:",
                                     "  1.0.0 1  "])
    end
  end

  context "formula with two releases and one dependency, none installed" do
    it "outputs info about two releases and one dependency" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb'
      crew 'info', 'libtwo'
      expect(result).to eq(:ok)
      expect(out.split("\n")).to eq(["Name:        libtwo",
                                     "Formula:     #{Global::FORMULA_DIR}/libtwo.rb",
                                     "Homepage:    http://www.libtwo.org",
                                     "Description: Library Two",
                                     "Type:        library",
                                     "Releases:",
                                     "  1.1.0 1  ",
                                     "  2.2.0 1  ",
                                     "Dependencies:",
                                     "  libone"])
    end
  end

  context "formula with three releases and two dependencies, none installed" do
    it "outputs info about three releases and two dependencies" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew 'info', 'libthree'
      expect(result).to eq(:ok)
      expect(out.split("\n")).to eq(["Name:        libthree",
                                     "Formula:     #{Global::FORMULA_DIR}/libthree.rb",
                                     "Homepage:    http://www.libthree.org",
                                     "Description: Library Three",
                                     "Type:        library",
                                     "Releases:",
                                     "  1.1.1 1  ",
                                     "  2.2.2 1  ",
                                     "  3.3.3 1  ",
                                     "Dependencies:",
                                     "  libone  libtwo"])
    end
  end

  context "formula with three releases and two dependencies, both dependencies installed" do
    it "outputs info about two releases and one dependency" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      crew_checked 'install', 'libtwo'
      crew 'info', 'libthree'
      expect(result).to eq(:ok)
      expect(out.split("\n")).to eq(["Name:        libthree",
                                     "Formula:     #{Global::FORMULA_DIR}/libthree.rb",
                                     "Homepage:    http://www.libthree.org",
                                     "Description: Library Three",
                                     "Type:        library",
                                     "Releases:",
                                     "  1.1.1 1  ",
                                     "  2.2.2 1  ",
                                     "  3.3.3 1  ",
                                     "Dependencies:",
                                     "  libone (*)  libtwo (*)"])
    end
  end
end
