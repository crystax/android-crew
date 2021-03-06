require_relative 'spec_helper.rb'

describe "crew info" do
  before(:all) do
    ndk_init
  end

  before(:each) do
    clean_cache
    clean_hold
    repository_init
    repository_clone
  end

  context "without argument" do
    it "outputs error message" do
      crew 'info'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires a formula argument')
    end
  end

  context "non existing name" do
    it "outputs error message" do
      crew 'info', 'foo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: no available formula for foo')
    end
  end

  context "about ruby, all utilities with one release each" do
    it "outputs info about ruby" do
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
      crew 'info', 'curl', 'libarchive', 'ruby', 'xz'
      expect(result).to eq(:ok)
      expect(out.split("\n")).to eq(["Name:        curl",
                                     "Formula:     #{Global::UTILITIES_DIR}/curl.rb",
                                     "Homepage:    http://curl.haxx.se/",
                                     "Description: Get a file from an HTTP, HTTPS or FTP server",
                                     "Type:        utility",
                                     "Releases:",
                                     "  7.42.0 1  installed",
                                     "",
                                     "Name:        libarchive",
                                     "Formula:     #{Global::UTILITIES_DIR}/libarchive.rb",
                                     "Homepage:    http://www.libarchive.org",
                                     "Description: Multi-format archive and compression library, bsdtar utility",
                                     "Type:        utility",
                                     "Releases:",
                                     "  3.1.2 1  installed",
                                     "",
                                     "Name:        ruby",
                                     "Formula:     #{Global::UTILITIES_DIR}/ruby.rb",
                                     "Homepage:    https://www.ruby-lang.org/",
                                     "Description: Powerful, clean, object-oriented scripting language",
                                     "Type:        utility",
                                     "Releases:",
                                     "  2.2.2 1  installed",
                                     "",
                                     "Name:        xz",
                                     "Formula:     #{Global::UTILITIES_DIR}/xz.rb",
                                     "Homepage:    http://tukaani.org/xz/",
                                     "Description: General-purpose data compression with high compression ratio",
                                     "Type:        utility",
                                     "Releases:",
                                     "  5.2.2 1  installed"])
    end
  end

  context "formula with one release and no dependencies, not installed" do
    it "outputs info about one not installed release with no dependencies" do
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
