require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew cleanup" do
  context "with wrong argument" do
    it "outputs error message" do
      clean
      crew 'cleanup', 'bar'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command accepts only one optional argument: -n')
    end
  end

  context "when there are no formulas and nothing installed" do
    it "outputs nothing" do
      clean
      crew 'cleanup'
      expect(err).to eq('')
      expect(out).to eq('')
      expect(exitstatus).to be_zero
    end
  end

  context "when one release installed" do
    it "outputs nothing" do
      clean
      copy_formulas 'libone.rb'
      install_release 'libone', '1.0.0'
      crew 'cleanup'
      expect(err).to eq('')
      expect(out).to eq('')
      expect(exitstatus).to be_zero
    end
  end

  context "when one release installed and -n specified" do
    it "outputs nothing" do
      clean
      copy_formulas 'libone.rb'
      install_release 'libone', '1.0.0'
      crew 'cleanup', '-n'
      expect(err).to eq('')
      expect(out).to eq('')
      expect(exitstatus).to be_zero
    end
  end

  context "when two releases installed" do
    it "outputs about removing libtwo 1.1.0" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libtwo', '2.2.0'
      crew 'cleanup'
      expect(err).to eq('')
      expect(out).to eq("removing: /Volumes/Source-HD/src/crew/test/ndk/sources/libtwo/1.1.0\n")
      expect(exitstatus).to be_zero
    end
  end

  context "when two releases installed and -n specified" do
    it "outputs that would remove libtwo 1.1.0" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libtwo', '2.2.0'
      crew 'cleanup', '-n'
      expect(err).to eq('')
      expect(out).to eq("would remove: /Volumes/Source-HD/src/crew/test/ndk/sources/libtwo/1.1.0\n")
      expect(exitstatus).to be_zero
    end
  end

  context "when of three formulas one release, two releases and three releases installed" do
    it "outputs about removing libtwo 1.1.0, libthree 1.1.1 and 2.2.2" do
      clean
      copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libtwo', '2.2.0'
      install_release 'libthree', '1.1.1'
      install_release 'libthree', '2.2.2'
      install_release 'libthree', '3.3.3'
      crew 'cleanup'
      expect(err).to eq('')
      expect(out).to eq("removing: /Volumes/Source-HD/src/crew/test/ndk/sources/libthree/1.1.1\n" \
                        "removing: /Volumes/Source-HD/src/crew/test/ndk/sources/libthree/2.2.2\n" \
                        "removing: /Volumes/Source-HD/src/crew/test/ndk/sources/libtwo/1.1.0\n")
      expect(exitstatus).to be_zero
    end
  end
end
