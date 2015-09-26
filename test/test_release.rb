require 'minitest/unit'
require_relative '../library/release.rb'

class TestRelease < MiniTest::Test

  def test_initialize
    # empty ctor
    r = Release.new
    assert_equal(r.version,         nil)
    assert_equal(r.crystax_version, nil)
    assert_equal(r.shasum,          '0')
    assert_equal(r.installed?,      nil)
    # one argument
    r = Release.new('1.2.3')
    assert_equal(r.version,         '1.2.3')
    assert_equal(r.crystax_version, nil)
    assert_equal(r.shasum,          '0')
    assert_equal(r.installed?,      nil)
    # two arguments
    r = Release.new('4.5.0', 7)
    assert_equal(r.version,         '4.5.0')
    assert_equal(r.crystax_version, 7)
    assert_equal(r.shasum,          '0')
    assert_equal(r.installed?,      nil)
    # three arguments
    r = Release.new('21.1.8', 3, 'c684cd6cd4eccfb478c79b8a12600cdfd7fd69beb575ec4f568dc17a7642d3e4')
    assert_equal(r.version,         '21.1.8')
    assert_equal(r.crystax_version, 3)
    assert_equal(r.shasum,          'c684cd6cd4eccfb478c79b8a12600cdfd7fd69beb575ec4f568dc17a7642d3e4')
    assert_equal(r.installed?,      nil)
  end

  def test_setters
    r = Release.new
    r.shasum = '1234567890'
    r.installed = true
    assert_equal(r.shasum,     '1234567890')
    assert_equal(r.installed?, true)
  end

  def test_update
    r1 = Release.new
    h1 = { version: '1' }
    r1.update h1
    assert_equal(r1.version, '1')
    #
    r2 = Release.new
    h2 = { version: '2', crystax_version: 2 }
    r2.update h2
    assert_equal(r2.version, '2')
    assert_equal(r2.crystax_version, 2)
    #
    r3 = Release.new
    h3 = { version: '3', crystax_version: 3, shasum: '333' }
    r3.update h3
    assert_equal(r3.version, '3')
    assert_equal(r3.crystax_version, 3)
    assert_equal(r3.shasum, '333')
  end

  def test_match
    r0 = Release.new
    r1 = Release.new('1.1.0')
    r2 = Release.new('1.1.0', 2)
    r3 = Release.new('3.3.3', 3)
    r4 = Release.new('3.3.3', 3, '1917-1991')
    r5 = Release.new('4.1.2', 4, '314159265358')
    r6 = Release.new('4.1.2', 4, '314159265358')
    r6.installed = true

    assert_equal(true,  r5.match?(r0))
    assert_equal(false, r5.match?(r1))
    assert_equal(false, r5.match?(r2))
    assert_equal(false, r5.match?(r3))
    assert_equal(false, r5.match?(r4))
    assert_equal(true,  r5.match?(r5))
    assert_equal(true,  r5.match?(r6))

    assert_equal(true,  r0.match?(r0))
    assert_equal(true,  r0.match?(r1))
    assert_equal(true,  r0.match?(r2))
    assert_equal(true,  r0.match?(r3))
    assert_equal(true,  r0.match?(r4))
    assert_equal(true,  r0.match?(r5))
    assert_equal(true,  r0.match?(r6))

    assert_equal(true,  r1.match?(r0))
    assert_equal(true,  r1.match?(r1))
    assert_equal(true,  r1.match?(r2))
    assert_equal(false, r1.match?(r3))
    assert_equal(false, r1.match?(r4))
    assert_equal(false, r1.match?(r5))
    assert_equal(false, r1.match?(r6))

    assert_equal(true,  r2.match?(r0))
    assert_equal(true,  r2.match?(r1))
    assert_equal(true,  r2.match?(r2))
    assert_equal(false, r2.match?(r3))
    assert_equal(false, r2.match?(r4))
    assert_equal(false, r2.match?(r5))
    assert_equal(false, r2.match?(r6))

    assert_equal(true,  r3.match?(r0))
    assert_equal(false, r3.match?(r1))
    assert_equal(false, r3.match?(r2))
    assert_equal(true,  r3.match?(r3))
    assert_equal(true,  r3.match?(r4))
    assert_equal(false, r3.match?(r5))
    assert_equal(false, r3.match?(r6))

    assert_equal(true,  r4.match?(r0))
    assert_equal(false, r4.match?(r1))
    assert_equal(false, r4.match?(r2))
    assert_equal(true,  r4.match?(r3))
    assert_equal(true,  r4.match?(r4))
    assert_equal(false, r4.match?(r5))
    assert_equal(false, r4.match?(r6))

    assert_equal(true,  r5.match?(r0))
    assert_equal(false, r5.match?(r1))
    assert_equal(false, r5.match?(r2))
    assert_equal(false, r5.match?(r3))
    assert_equal(false, r5.match?(r4))
    assert_equal(true,  r5.match?(r5))
    assert_equal(true,  r5.match?(r6))

    assert_equal(true,  r6.match?(r0))
    assert_equal(false, r6.match?(r1))
    assert_equal(false, r6.match?(r2))
    assert_equal(false, r6.match?(r3))
    assert_equal(false, r6.match?(r4))
    assert_equal(true,  r6.match?(r5))
    assert_equal(true,  r6.match?(r6))
  end

  def test_to_s
    r = Release.new
    assert_equal(r.to_s, '_')
    #
    r = Release.new('2.0.0')
    assert_equal(r.to_s, '2.0.0_')
    # two arguments
    r = Release.new('3.3.0', 3)
    assert_equal(r.to_s, '3.3.0_3')
    # three arguments
    r = Release.new('24.5.1', 4, '1812')
    assert_equal(r.to_s, '24.5.1_4')
  end
end
