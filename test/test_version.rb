require 'test_helper'
require 'fattr'

class TestVersion < ::Minitest::Test
  def test_version_constant_match
    assert_match(/\A\d+\.\d+\.\d+\Z/, Fattr::Version)
  end

  def test_version_string_match
    assert_match(/\A\d+\.\d+\.\d+\Z/, Fattr::Version.to_s)
  end
end
