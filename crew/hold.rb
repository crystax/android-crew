require 'fileutils'
require_relative 'global.rb'


class Hold

  def self.standard_dir?(name)
    STANDARD_DIRS.include?(name)
  end

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
        if !version or version == lib[:version]
          answer = true
          break
        end
      end
    end
    answer
  end

  private

    STANDARD_DIRS = ['android', 'cpufeatures', 'crystax', 'cxx-stl', 'host-tools', 'objc', 'third_party']
end
