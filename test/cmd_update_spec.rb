require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew update" do
  context "with argument" do
    it "outputs error message" do
      clean
      crew 'update', 'baz'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires no arguments')
    end
  end

  context "when there are no formulas and no changes" do
    it "outputs nothing" do
      repository_init
      repository_clone
      crew 'update'
      expect(result).to eq(:ok)
      expect(out).to eq("Already up-to-date.\n")
    end
  end

  context "when there is one new formula" do
    it "says about one new formula" do
      repository_init
      repository_clone
      repository_add_formula 'libone.rb'
      crew 'update'
      expect(err).to eq('')
      expect(out).to match("Updated Crew from .* to .*.\n" \
                           "==> New Formulae\n"            \
                           "libone\n")
      expect(exitstatus).to be_zero
    end
  end

  context "when there is one modified formula and one new formula" do
    it "says about one modified and one new formula" do
      repository_init
      repository_add_formula 'libtwo-1.rb:libtwo.rb'
      repository_clone
      repository_add_formula 'libone.rb', 'libtwo.rb'
      crew 'update'
      expect(err).to eq('')
      expect(out).to match("Updated Crew from .* to .*.\n" \
                           "==> New Formulae\n"            \
                           "libone\n"                      \
                           "==> Updated Formulae\n"        \
                           "libtwo\n")
      expect(exitstatus).to be_zero
    end
  end

  context "when there is one modified formula, one new formula and one deleted formula" do
    it "says about one modified and one new formula" do
      repository_init
      repository_add_formula 'libtwo-1.rb:libtwo.rb', 'libthree.rb'
      repository_clone
      repository_add_formula 'libone.rb', 'libtwo.rb'
      repository_del_formula 'libthree.rb'
      crew 'update'
      expect(err).to eq('')
      expect(out).to match("Updated Crew from .* to .*.\n" \
                           "==> New Formulae\nlibone\n"    \
                           "==> Updated Formulae\n"        \
                           "libtwo\n"                      \
                           "==> Deleted Formulae\n"        \
                           "libthree\n")
      expect(exitstatus).to be_zero
    end
  end
end
