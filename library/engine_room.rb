require 'fileutils'
require_relative 'global.rb'

class EngineRoom

  UTILS = ['curl', 'p7zip', 'ruby']

  def initialize
    @data = Hash.new(['', ''])
    UTILS.each { |n| @data[n] = read_data(n) }
  end

  def installed?(name, props)
    v = @data[name]
    (v[0] == props[:version]) and (v[1] == props[:crystax_version])
  end

  private

  def read_data(util)
    arr = Dir.entries(File.join(Global::TOOLS_DIR, 'crew', util)).select { |a| a != '.' and a != '..' }
    raise "broken utility #{util} directory: #{arr}" unless arr.size == 1
    Formula.split_package_version arr[0]
  end
end
