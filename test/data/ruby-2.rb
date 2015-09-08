class Ruby < Formula
  include Utility

  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"

  release version: '2.2.2', crystax_version: 1, sha256: '0'
  release version: '2.2.3', crystax_version: 1, sha256: '0'

  def link(ndk_dir, platform, version)
    FileUtils.cd(dest_dir(ndk_dir, platform, 'bin')) do
      prog_ruby = exec_name(platform, 'ruby')
      FileUtils.rm_rf prog_ruby
      FileUtils.ln_s File.join(src_dir(version, 'bin'), prog_ruby), prog_ruby
      FileUtils.rm_rf 'rspec'
      FileUtils.ln_s File.join(src_dir(version, 'bin'), 'rspec'), 'rspec'
    end
    FileUtils.cd(dest_dir(ndk_dir, platform, 'lib')) do
      FileUtils.rm_rf 'ruby'
      FileUtils.ln_s File.join(src_dir(version, 'lib'), 'ruby'), 'ruby'
    end
  end
end
