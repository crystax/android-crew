require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew upgrade" do
  context "with argument" do
    it "outputs error message" do
      clean
      crew 'upgrade', 'baz'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires no arguments')
    end
  end

  context "when there are no formulas and no changes" do
    it "outputs nothing" do
      repository_init
      repository_clone
      crew 'update'
      crew 'upgrade'
      expect(err).to eq('')
      expect(out).to eq('')
      expect(exitstatus).to be_zero
    end
  end

  context "when there is one new release in one formula" do
    it "says about installing new release" do
      repository_init
      repository_add_formula 'libone.rb', 'libtwo-1.rb:libtwo.rb'
      repository_clone
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      repository_add_formula 'libtwo.rb'
      crew 'update'
      crew 'upgrade'
      expect(err).to eq('')
      expect(out).to eq("Will install: libtwo-2.2.0\n"                                \
                        "downloading http://ithilien.local:9999/libtwo-2.2.0.7z\n"    \
                        "checking integrity of the downloaded file libtwo-2.2.0.7z\n" \
                        "unpacking archive\n")
      expect(exitstatus).to be_zero
    end
  end

  context "when there are two formulas with new release in each" do
    it "says about installing new releases" do
      repository_init
      repository_add_formula 'libone.rb', 'libtwo-1.rb:libtwo.rb', 'libthree-2.rb:libthree.rb'
      repository_clone
      install_release 'libone', '1.0.0'
      install_release 'libtwo', '1.1.0'
      install_release 'libthree', '1.1.1'
      repository_add_formula 'libtwo.rb', 'libthree.rb'
      crew 'update'
      crew 'upgrade'
      expect(err).to eq('')
      expect(out).to eq("Will install: libthree-3.3.3 libtwo-2.2.0\n"                   \
                        "downloading http://ithilien.local:9999/libthree-3.3.3.7z\n"    \
                        "checking integrity of the downloaded file libthree-3.3.3.7z\n" \
                        "unpacking archive\n"                                           \
                        "downloading http://ithilien.local:9999/libtwo-2.2.0.7z\n"      \
                        "checking integrity of the downloaded file libtwo-2.2.0.7z\n"   \
                        "unpacking archive\n")
      expect(exitstatus).to be_zero
    end
  end
end
