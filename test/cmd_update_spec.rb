require_relative 'spec_helper.rb'
require_relative '../library/global.rb'

describe "crew update" do
  before(:all) do
    ndk_init
  end

  before(:each) do
    clean_cache
    clean_hold
    repository_init
    repository_clone
  end

  context "with argument" do
    it "outputs error message" do
      crew 'update', 'baz'
      expect(exitstatus).to_not be_zero
      expect(err.chomp).to eq('error: this command requires no arguments')
    end
  end

  context "when there are no formulas and no changes" do
    it "outputs nothing" do
      crew 'update'
      expect(result).to eq(:ok)
      expect(out).to eq("Already up-to-date.\n")
    end
  end

  context "when there are changes only in libraries" do

    context "when there is one new formula" do
      it "says about one new formula" do
        repository_add_formula :library, 'libone.rb'
        crew 'update'
        expect(result).to eq(:ok)
        expect(out).to match("Updated Crew from .* to .*.\n" \
                             "==> New Formulae\n"            \
                             "libone\n")
      end
    end

    context "when there is one modified formula and one new formula" do
      it "says about one modified and one new formula" do
        repository_add_formula :library, 'libtwo-1.rb:libtwo.rb'
        repository_clone
        repository_add_formula :library, 'libone.rb', 'libtwo.rb'
        crew 'update'
        expect(result).to eq(:ok)
        expect(out).to match("Updated Crew from .* to .*.\n" \
                             "==> New Formulae\n"            \
                             "libone\n"                      \
                             "==> Updated Formulae\n"        \
                             "libtwo\n")
      end
    end

    context "when there is one modified formula, one new formula and one deleted formula" do
      it "says about one modified and one new formula" do
        repository_add_formula :library, 'libtwo-1.rb:libtwo.rb', 'libthree.rb'
        repository_clone
        repository_add_formula :library, 'libone.rb', 'libtwo.rb'
        repository_del_formula 'libthree.rb'
        crew 'update'
        expect(result).to eq(:ok)
        expect(out).to match("Updated Crew from .* to .*.\n" \
                             "==> New Formulae\n"            \
                             "libone\n"                      \
                             "==> Updated Formulae\n"        \
                             "libtwo\n"                      \
                             "==> Deleted Formulae\n"        \
                             "libthree\n")
      end
    end
  end

  context "when there are changes only in utilities" do

    context "when there is one updated utility" do
      it "says about updated utility" do
        repository_add_formula :utility, 'curl-2.rb:curl.rb'
        crew 'update'
        expect(result).to eq(:ok)
        expect(out).to match("Updated Crew from .* to .*.\n" \
                             "==> Updated Utilities\n"       \
                             "curl\n")
      end
    end

    context "when there are two updated utilities" do
      it "says about updated utilities" do
        repository_add_formula :utility, 'curl-2.rb:curl.rb', 'ruby-2.rb:ruby.rb'
        crew 'update'
        expect(result).to eq(:ok)
        expect(out).to match("Updated Crew from .* to .*.\n" \
                             "==> Updated Utilities\n"       \
                             "curl, ruby\n")
      end
    end

    context "when there are four updated utilities" do
      it "says about updated utilities" do
        repository_add_formula :utility, 'curl-2.rb:curl.rb', 'libarchive-2.rb:libarchive.rb', 'ruby-2.rb:ruby.rb', 'xz-2.rb:xz.rb'
        crew 'update'
        expect(result).to eq(:ok)
        expect(out).to match("Updated Crew from .* to .*.\n" \
                             "==> Updated Utilities\n"       \
                             "curl, libarchive, ruby, xz\n")
      end
    end
  end

  context "where there are changes in libraries and utilities" do

    context "when there is one modified formula, one new formula, one deleted formula, and three updated utilities" do
      it "ouputs info about all changes" do
        repository_add_formula :library, 'libtwo-1.rb:libtwo.rb', 'libthree.rb'
        repository_clone
        repository_add_formula :library, 'libone.rb', 'libtwo.rb'
        repository_del_formula 'libthree.rb'
        repository_add_formula :utility, 'curl-2.rb:curl.rb', 'ruby-2.rb:ruby.rb', 'xz-2.rb:xz.rb'
        crew 'update'
        expect(result).to eq(:ok)
        expect(out).to match("Updated Crew from .* to .*.\n" \
                             "==> Updated Utilities\n"       \
                             "curl, ruby, xz\n"              \
                             "==> New Formulae\n"            \
                             "libone\n"                      \
                             "==> Updated Formulae\n"        \
                             "libtwo\n"                      \
                             "==> Deleted Formulae\n"        \
                             "libthree\n")
      end
    end
  end
end
