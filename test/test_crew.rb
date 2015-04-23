require 'minitest/autorun'
require_relative '../crew.rb'

class TestCrewSplitArgument < MiniTest::Test

  def test_no_args
    goptions, cmd, args = split_arguments([])
    assert_equal(goptions, [])
    assert_equal(cmd, 'help')
    assert_equal(args, [])
  end

  def test_one_global_option
    goptions, cmd, args = split_arguments(['--backtrace'])
    assert_equal(goptions, ['--backtrace'])
    assert_equal(cmd, 'help')
    assert_equal(args, [])
  end

  def test_two_global_options
    goptions, cmd, args = split_arguments(['--backtrace', '--log'])
    assert_equal(goptions, ['--backtrace', '--log'])
    assert_equal(cmd, 'help')
    assert_equal(args, [])
  end

  def test_only_command
    goptions, cmd, args = split_arguments(['version'])
    assert_equal(goptions, [])
    assert_equal(cmd, 'version')
    assert_equal(args, [])
  end

  def test_one_global_option_and_command
    goptions, cmd, args = split_arguments(['--backtrace', 'list'])
    assert_equal(goptions, ['--backtrace'])
    assert_equal(cmd, 'list')
    assert_equal(args, [])
  end

  def test_two_global_options_and_command
    goptions, cmd, args = split_arguments(['--backtrace', '-b', 'update'])
    assert_equal(goptions, ['--backtrace', '-b'])
    assert_equal(cmd, 'update')
    assert_equal(args, [])
  end

  def test_command_and_one_argument
    goptions, cmd, args = split_arguments(['cleanup', '-n'])
    assert_equal(goptions, [])
    assert_equal(cmd, 'cleanup')
    assert_equal(args, ['-n'])
  end

  def test_command_and_three_arguments
    goptions, cmd, args = split_arguments(['install', 'foo', 'bar', 'baz'])
    assert_equal(goptions, [])
    assert_equal(cmd, 'install')
    assert_equal(args, ['foo', 'bar', 'baz'])
  end

  def test_two_global_options_command_and_three_arguments
    goptions, cmd, args = split_arguments(['--backtrace', '-b', 'install', 'foo', 'bar', 'baz'])
    assert_equal(goptions, ['--backtrace', '-b'])
    assert_equal(cmd, 'install')
    assert_equal(args, ['foo', 'bar', 'baz'])
  end
end

class TestCrewRequireCommand < MiniTest::Test

  def test_existing_command
    assert_equal(true, require_command('help'))
  end

  def test_non_existing_command
    assert_raises(UnknownCommand) { require_command('bla_bla_bla') }
  end

  def test_syntax_error
    file = 'syntax_error.rb'
    src = File.join('data', file)
    dst = File.join('..', 'library', 'cmd', file)
    FileUtils.cp(src, dst)

    assert_raises(SyntaxError) { require_command('syntax_error') }

    FileUtils.remove(dst)
  end

  def test_file_not_readable
    file = 'syntax_error.rb'
    src = File.join('data', file)
    dst = File.join('..', 'library', 'cmd', file)
    FileUtils.cp src, dst
    FileUtils.chmod "a-r", dst

    # on windows chmod does not work
    if RUBY_PLATFORM =~ /mingw/
      assert_raises(SyntaxError) { require_command('syntax_error') }
    else
      assert_raises(UnknownCommand) { require_command('syntax_error') }
    end

    FileUtils.remove(dst)
  end
end
