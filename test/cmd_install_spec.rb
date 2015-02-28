require_relative 'spec_helper.rb'

describe "crew install" do
  context "without argument" do
    it "outputs error message" do
      clean
      crew 'install'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires a formula argument')
    end
  end

  context "non existing name" do
    it "outputs error message" do
      clean
      crew 'install', 'foo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: no available formula for foo')
    end
  end

  context "existing formula with one release and bad sha256 sum of the downloaded file" do
    it "outputs info about installing existing release" do
      clean
      copy_formulas 'libbad.rb'
      file = "#{Global::CACHE_DIR}/libbad-1.0.0.7z"
      crew 'install', 'libbad'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq("error: bad SHA256 sum of the downloaded file #{file}")
    end
  end

  context "existing formula with one release" do
    it "outputs info about installing existing release" do
      clean
      copy_formulas 'libone.rb'
      file = 'libone-1.0.0.7z'
      url = "#{Global::DOWNLOAD_BASE}/#{file}"
      crew 'install', 'libone'
      expect(exitstatus).to be_zero
      expect(out).to eq("calculating dependencies for libone: \n"             +
                        "  dependencies to install: [] \n"                    +
                        "  space required: 0\n"                               +
                        "downloading #{url}\n"                                +
                        "checking integrity of the downloaded file #{file}\n" +
                        "unpacking archive\n")
    end
  end

  context "existing formula with two releases and one dependency" do
    it "outputs info about installing dependency and the latest release" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb'
      depfile = 'libone-1.0.0.7z'
      depurl = "#{Global::DOWNLOAD_BASE}/#{depfile}"
      resfile = 'libtwo-2.2.0.7z'
      resurl = "#{Global::DOWNLOAD_BASE}/#{resfile}"
      crew 'install', 'libtwo'
      expect(err).to eq('')
      expect(exitstatus).to be_zero
      expect(out).to eq("calculating dependencies for libtwo: \n"                +
                        "  dependencies to install: [libone] \n"                 +
                        "  space required: 0\n"                                  +
                        "installing dependencies for libtwo:\n"                  +
                        "downloading #{depurl}\n"                                +
                        "checking integrity of the downloaded file #{depfile}\n" +
                        "unpacking archive\n"                                    +
                        "\n"                                                     +
                        "downloading #{resurl}\n"                                +
                        "checking integrity of the downloaded file #{resfile}\n" +
                        "unpacking archive\n")
    end
  end

  context "specific release of the existing formula with three releases and two dependencies" do
    it "outputs info about installing dependencies and the specified release" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      depfile1 = 'libone-1.0.0.7z'
      depurl1 = "#{Global::DOWNLOAD_BASE}/#{depfile1}"
      depfile2 = 'libtwo-2.2.0.7z'
      depurl2 = "#{Global::DOWNLOAD_BASE}/#{depfile2}"
      resfile = 'libthree-2.2.2.7z'
      resurl = "#{Global::DOWNLOAD_BASE}/#{resfile}"
      crew 'install', 'libthree:2.2.2'
      expect(err).to eq('')
      expect(exitstatus).to be_zero
      expect(out).to eq("calculating dependencies for libthree: \n"                     +
                        "  dependencies to install: [libone, libtwo] \n"                +
                        "  space required: 0\n"                                         +
                        "installing dependencies for libthree:\n"                       +
                        "downloading #{depurl1}\n"                                      +
                        "checking integrity of the downloaded file #{depfile1}\n"       +
                        "unpacking archive\n"                                           +
                        "downloading #{depurl2}\n"                                      +
                        "checking integrity of the downloaded file #{depfile2}\n"       +
                        "unpacking archive\n"                                           +
                        "\n"                                                            +
                        "downloading #{resurl}\n"                                       +
                        "checking integrity of the downloaded file #{resfile}\n"        +
                        "unpacking archive\n")
    end
  end
end
