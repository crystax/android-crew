require 'fileutils'
require_relative 'global.rb'
require_relative 'utils.rb'


class Hold

  attr_reader :installed

  def initialize
    @installed = Hash.new {|h, k| h[k] = [] }
    FileUtils.cd(Global::HOLD_DIR) do
      Dir.foreach('.') do |name|
        if name == '.' or name == '..' or !File.directory?(name) or Hold.standard_dir?(name)
          next
        end
        FileUtils.cd(name) do
          Dir.foreach('.') do |ver|
            if ver == '.' or ver == '..'
              next
            end
            if !File.directory?(ver)
              warning("directory #e{File.join(Global::HOLD_DIR, name)} contains foreign object #{ver}")
            else
              @installed[name] << ver
            end
          end
        end
      end
    end
  end

  def installed?(name, version = nil)
    answer = false
    @installed.each_pair do |n, vers|
      if n == name
        if !version or version == 'all' or vers.include?(version)
          answer = true
          break
        end
      end
    end
    answer
  end

  def installed_versions(name)
    @installed[name]
  end

  def self.install_release(name, version, archive)
    outdir = release_directory(name, version)
    FileUtils.mkdir_p(outdir)
    puts "unpacking archive"
    Utils.unpack(archive, outdir)
  rescue
    FileUtils.rmdir(outdir) unless Global::DEBUG.include?(:temps)
    raise
  end

  def self.remove(name, version)
    FileUtils.cd(Global::HOLD_DIR) do
      FileUtils.cd(name) do
        Dir.foreach('.') do |dir|
          if !(dir == '.' or dir == '..') and (dir == version or version == 'all')
            puts "uninstalling #{name}-#{dir}"
            FileUtils.remove_dir(dir)
          end
        end
      end
      # remove lib directory if it's empty
      if Dir.entries(name).size == 2
        Dir.rmdir(name)
      end
    end
  end

  def self.release_directory(name, version)
    File.join(Global::HOLD_DIR, name, version)
  end

  private

  STANDARD_DIRS = ['android', 'cpufeatures', 'crystax', 'cxx-stl', 'host-tools', 'objc', 'third_party']

  def self.standard_dir?(name)
    STANDARD_DIRS.include?(name)
  end
end
