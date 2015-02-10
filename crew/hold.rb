require 'fileutils'
require_relative 'global.rb'
require_relative 'utils.rb'


class Hold

  def initialize
    @installed = []
    FileUtils.cd(Global::HOLD_DIR) {
      Dir.foreach('.') do |name|
        if name == '.' or name == '..' or !File.directory?(name) or self.class.standard_dir?(name)
          next
        end
        FileUtils.cd(name) {
          Dir.foreach('.') do |ver|
            if ver == '.' or ver == '..'
              next
            end
            if !File.directory?(ver)
              warning "directory #{File.join(Global::HOLD_DIR, name)} contains foreign object #{ver}"
            end
            # todo: create version object
            @installed << {name: name, version: ver}
          end
        }
      end
    }
  end

  def installed?(name, version = nil)
    answer = false
    @installed.each do |lib|
      if lib[:name] == name
        if !version or version == 'all' or version == lib[:version]
          answer = true
          break
        end
      end
    end
    answer
  end

  def installed_versions(name)
    # todo: all
    list = []
    @installed.each do |lib|
      if lib[:name] == name
        list << lib[:version]
      end
    end
    list
  end

  def remove(name, version)
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

  def self.standard_dir?(name)
    STANDARD_DIRS.include?(name)
  end

  def self.install_release(name, version, path)
    dir = File.join(Global::HOLD_DIR, name, version)
    begin
      FileUtils.mkdir_p(dir)
      puts "unpacking archive"
      unpack_archive(path, dir)
    rescue
      FileUtils.rmdir(dir) unless Global::CREW_DEBUG.include?(:temps)
      raise
    end
  end

  private

    STANDARD_DIRS = ['android', 'cpufeatures', 'crystax', 'cxx-stl', 'host-tools', 'objc', 'third_party']
end
