require_relative 'spec_helper.rb'

describe "crew install" do
  before(:each) do
      clean
  end

  context "without argument" do
    it "outputs error message" do
      crew 'install'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires a formula argument')
      expect(cache_empty?).to eq(true)
    end
  end

  context "non existing name" do
    it "outputs error message" do
      crew 'install', 'foo'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: no available formula for foo')
      expect(cache_empty?).to eq(true)
    end
  end

  context "existing formula with one release and bad sha256 sum of the downloaded file" do
    it "outputs error message" do
      copy_formulas 'libbad.rb'
      file = File.join(Global::CACHE_DIR, 'libbad-1.0.0_1.7z')
      crew 'install', 'libbad'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq("error: bad SHA256 sum of the downloaded file #{file}")
      expect(in_cache?('libbad', '1.0.0', 1)).to eq(true)
    end
  end

  context "existing formula with one release, no dependencies, specifing only name" do
    it "outputs info about installing existing release" do
      copy_formulas 'libone.rb'
      file = 'libone-1.0.0_1.7z'
      url = "#{Global::DOWNLOAD_BASE}/packages/libone/#{file}"
      crew 'install', 'libone'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libone: \n"             \
                        "  dependencies to install: \n"                       \
                        "downloading #{url}\n"                                \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
    end
  end

  context "existing formula with one release, no dependencies, specifing name and version" do
    it "outputs info about installing existing release" do
      copy_formulas 'libone.rb'
      file = 'libone-1.0.0_1.7z'
      url = "#{Global::DOWNLOAD_BASE}/packages/libone/#{file}"
      crew 'install', 'libone:1.0.0'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libone: \n"             \
                        "  dependencies to install: \n"                       \
                        "downloading #{url}\n"                                \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
    end
  end

  context "existing formula with one release, no dependencies, specifing full release info" do
    it "outputs info about installing existing release" do
      copy_formulas 'libone.rb'
      file = 'libone-1.0.0_1.7z'
      url = "#{Global::DOWNLOAD_BASE}/packages/libone/#{file}"
      crew 'install', 'libone:1.0.0:1'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libone: \n"             \
                        "  dependencies to install: \n"                       \
                        "downloading #{url}\n"                                \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
    end
  end

  context "existing formula with one release, no dependencies, specifing non existing version" do
    it "outputs info about installing existing release" do
      copy_formulas 'libone.rb'
      crew 'install', 'libone:2.0.0'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: libone has no release with version 2.0.0')
    end
  end

  context "existing formula with one release, no dependencies, specifing non existing crystax_version" do
    it "outputs info about installing existing release" do
      copy_formulas 'libone.rb'
      crew 'install', 'libone:1.0.0:10'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: libone has no release 1.0.0:10')
    end
  end

  context "existing formula with two versions and one dependency" do
    it "outputs info about installing dependency and the latest version" do
      copy_formulas 'libone.rb', 'libtwo.rb'
      depfile = 'libone-1.0.0_1.7z'
      depurl = "#{Global::DOWNLOAD_BASE}/packages/libone/#{depfile}"
      resfile = 'libtwo-2.2.0_1.7z'
      resurl = "#{Global::DOWNLOAD_BASE}/packages/libtwo/#{resfile}"
      crew 'install', 'libtwo'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libtwo: \n"                \
                        "  dependencies to install: libone\n"                    \
                        "installing dependencies for libtwo:\n"                  \
                        "downloading #{depurl}\n"                                \
                        "checking integrity of the downloaded file #{depfile}\n" \
                        "unpacking archive\n"                                    \
                        "\n"                                                     \
                        "downloading #{resurl}\n"                                \
                        "checking integrity of the downloaded file #{resfile}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?('libtwo', '2.2.0', 1)).to eq(true)
    end
  end

  context "specific release of the existing formula with three releases and two dependencies" do
    it "outputs info about installing dependencies and the specified release" do
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      depfile1 = 'libone-1.0.0_1.7z'
      depurl1 = "#{Global::DOWNLOAD_BASE}/packages/libone/#{depfile1}"
      depfile2 = 'libtwo-2.2.0_1.7z'
      depurl2 = "#{Global::DOWNLOAD_BASE}/packages/libtwo/#{depfile2}"
      resfile = 'libthree-2.2.2_1.7z'
      resurl = "#{Global::DOWNLOAD_BASE}/packages/libthree/#{resfile}"
      crew 'install', 'libthree:2.2.2:1'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libthree: \n"               \
                        "  dependencies to install: libone, libtwo\n"             \
                        "installing dependencies for libthree:\n"                 \
                        "downloading #{depurl1}\n"                                \
                        "checking integrity of the downloaded file #{depfile1}\n" \
                        "unpacking archive\n"                                     \
                        "downloading #{depurl2}\n"                                \
                        "checking integrity of the downloaded file #{depfile2}\n" \
                        "unpacking archive\n"                                     \
                        "\n"                                                      \
                        "downloading #{resurl}\n"                                 \
                        "checking integrity of the downloaded file #{resfile}\n"  \
                        "unpacking archive\n")
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
      expect(in_cache?('libtwo', '2.2.0', 1)).to eq(true)
      expect(in_cache?('libthree', '2.2.2', 1)).to eq(true)
    end
  end

  context "existing formula with one release from the cache" do
    it "outputs info about using cached file" do
      copy_formulas 'libone.rb'
      file = 'libone-1.0.0_1.7z'
      crew_checked 'install', 'libone'
      crew_checked '-b', 'remove', 'libone'
      crew 'install', 'libone'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libone: \n"             \
                        "  dependencies to install: \n"                       \
                        "using cached file #{file}\n"                         \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libone', '1.0.0', 1)).to eq(true)
    end
  end

  context "existing formula with four versions, 11 releases, specifying only name" do
    it "outputs info about installing latest release" do
      copy_formulas 'libfour.rb'
      file = 'libfour-4.4.4_4.7z'
      url = "#{Global::DOWNLOAD_BASE}/packages/libfour/#{file}"
      crew 'install', 'libfour'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libfour: \n"            \
                        "  dependencies to install: \n"                       \
                        "downloading #{url}\n"                                \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libfour', '4.4.4', 4)).to eq(true)
    end
  end

  context "existing formula with four versions, 11 releases, specifying name and version" do
    it "outputs info about installing latest crystax_version of the specified version" do
      copy_formulas 'libfour.rb'
      file = 'libfour-3.3.3_3.7z'
      url = "#{Global::DOWNLOAD_BASE}/packages/libfour/#{file}"
      crew 'install', 'libfour:3.3.3'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libfour: \n"            \
                        "  dependencies to install: \n"                       \
                        "downloading #{url}\n"                                \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libfour', '3.3.3', 3)).to eq(true)
    end
  end

  context "existing formula with four versions, 11 releases, specifying name, version, crystax_version" do
    it "outputs info about installing the specified release" do
      copy_formulas 'libfour.rb'
      file = 'libfour-2.2.2_1.7z'
      url = "#{Global::DOWNLOAD_BASE}/packages/libfour/#{file}"
      crew 'install', 'libfour:2.2.2:1'
      expect(result).to eq(:ok)
      expect(out).to eq("calculating dependencies for libfour: \n"            \
                        "  dependencies to install: \n"                       \
                        "downloading #{url}\n"                                \
                        "checking integrity of the downloaded file #{file}\n" \
                        "unpacking archive\n")
      expect(in_cache?('libfour', '2.2.2', 1)).to eq(true)
    end
  end
end
