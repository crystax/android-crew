class UsageError < RuntimeError; end


class FormulaUnspecifiedError < UsageError; end


class UnknownCommand < UsageError
  def initialize(cmd)
    super "unknown command \'#{cmd}\'"
  end
end


class CommandRequresNoArguments < UsageError
  def initialize(cmd, args)
    super "command \'#{cmd}\' does not requires arguments: \'#{args}\'"
  end
end
