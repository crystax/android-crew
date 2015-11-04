class UsageError < RuntimeError; end

class FormulaUnspecifiedError < UsageError
  def to_s
    "this command requires a formula argument"
  end
end

class CommandRequresNoArguments < UsageError
  def to_s
    "this command requires no arguments"
  end
end

class CommandRequresOneOrNoArguments < UsageError
  def to_s
    "this command requires either one or no arguments"
  end
end

class UnknownCommand < UsageError
  def initialize(cmd)
    super "unknown command \'#{cmd}\'"
  end
end

class FormulaUnavailableError < RuntimeError

  attr_reader :name

  def initialize(name)
    super "no available formula for #{name}"
    @name = name
  end
end

class ErrorDuringExecution < RuntimeError

  attr_reader :exit_code, :error_text

  def initialize(cmd, exitcode, err)
    @exit_code = exitcode
    @error_text = err

    msg = err.size > 0 ? "#{cmd}; error output: #{err}" : "#{cmd}"
    super "Failure while executing: #{msg}; exit code: #{exit_code}"
  end
end

class ReleaseNotFound < RuntimeError
  def initialize(name, release)
    msg = !release.crystax_version ? "with version #{release.version}" : "#{release.version}:#{release.crystax_version}"
    super "#{name} has no release #{msg}"
  end
end

class DownloadError < RuntimeError

  attr_reader :url, :error_code

  def initialize(url, error_code, text = nil)
    @url = url
    @error_code = error_code
    msg = text ? "; text: #{text}" : ''
    super "failed to download #{url}: code: #{error_code}#{msg}"
  end
end
