class UsageError < RuntimeError; end

class FormulaUnspecifiedError < UsageError; end

class LibraryUnspecifiedError < UsageError; end

class CommandRequresNoArguments < UsageError; end


class UnknownCommand < UsageError
  def initialize(cmd)
    super "unknown command \'#{cmd}\'"
  end
end


class FormulaUnavailableError < RuntimeError
  attr_reader :name
  attr_accessor :dependent

  def initialize name
    @name = name
  end

  def dependent_s
    "(dependency of #{dependent})" if dependent and dependent != name
  end

  def to_s
    "No available formula for #{name} #{dependent_s}"
  end
end

class ErrorDuringExecution < RuntimeError
  def initialize(cmd, err)
    msg = err.size > 0 ? "#{cmd}; error output: #{err}" : "#{cmd}"
    super "Failure while executing: #{msg}"
  end
end
