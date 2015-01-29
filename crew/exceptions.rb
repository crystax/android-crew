class UnknownCommand < StandardError
  attr_reader :cmd

  def initialize(cmd)
    @cmd = cmd
    super "unknown command \'#{cmd}\'"
  end
end


class CommandRequresNoArguments < StandardError
  attr_reader :cmd, :args
  
  def initialize(cmd, args)
    @cmd = cmd
    @args = args
    super "command \'#{cmd}\' does not requires arguments: \'#{args}\'"
  end
end
