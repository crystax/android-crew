require 'fileutils'
require 'json'
require 'digest'
require 'rugged'
require_relative 'library/extend/module.rb'
require_relative 'library/utils.rb'
require_relative 'library/exceptions.rb'
require_relative 'library/global.rb'
require_relative 'library/formula.rb'
require_relative 'library/formulary.rb'
require_relative 'library/library.rb'
require_relative 'library/utility.rb'


def split_arguments(arguments)
  goptions = []
  cmd = 'help'
  args = []
  # get global options
  arguments.each.with_index do |arg, index|
    if arg =~ /^-.*/
      goptions << arg
    else
      cmd = arg.to_s.gsub('-', '_').downcase
      args = arguments.slice(index + 1, arguments.length)
      break
    end
  end
  [goptions, cmd, args]
end

def require_command(cmd)
  path = File.join("library", "cmd", cmd + '.rb')
  require_relative path
rescue LoadError => e
  raise UnknownCommand, cmd, e.backtrace
end


if __FILE__ == $0
  begin
    Global.check_program(Global::CREW_CURL_PROG)
    Global.check_program(Global::CREW_7Z_PROG)

    goptions, cmd, args = split_arguments(ARGV)
    Global.set_options(goptions)

    FileUtils.cd(Global::REPOSITORY_DIR) do
      require_command(cmd)
      Crew.send(cmd, args)
    end
  rescue Exception => e
    exception(e)
    exit 1
  else
    #exit 1 if Crew.failed?
    # todo: 0 or 1 here?
    exit 0
  end
end
