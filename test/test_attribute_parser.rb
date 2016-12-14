require 'test_helper'
require 'fattr'

class TestAttributeParser < ::Minitest::Test

  def setup
    @args   = %i[ a b c ]
    @kwargs = { :x => "foo", :y => "bar", :z => "baz" }
    @block  = lambda { |*ignored| 42 }
  end

  def test_empty_args_and_kwargs
    assert_equal([], ::Fattr::AttributeParser.call([], {}))
  end

  def test_array_as_first_args_param
    args = [ @args ]
    parsed = ::Fattr::AttributeParser.call(args)
    assert_equal(3, parsed.size)
    @args.each_with_index do |name, idx|
      attribute = parsed[idx]
      assert_equal(name.to_s, attribute.name)
    end
  end

  def test_only_attributes_with_defaults
    parsed = ::Fattr::AttributeParser.call([], @kwargs)
    assert_equal(3, parsed.size)

    @kwargs.keys.each_with_index do |name, idx|
      attribute = parsed[idx]
      assert_equal(name.to_s, attribute.name)
      assert_equal(@kwargs[name], attribute.default.call)
    end
  end

  def test_only_named_attributes
    parsed = ::Fattr::AttributeParser.call(@args, {})
    assert_equal(3, parsed.size)

    @args.each_with_index do |name, idx|
      attribute = parsed[idx]
      assert_equal(name.to_s, attribute.name)
    end
  end

  def test_named_attributes_some_with_defaults
    parsed = ::Fattr::AttributeParser.call(@args, @kwargs)
    assert_equal(6, parsed.size)

    @args.each_with_index do |name, idx|
      attribute = parsed[idx]
      assert_equal(name.to_s, attribute.name)
    end

    @kwargs.keys.each_with_index do |name, idx|
      attribute = parsed[idx+3]
      assert_equal(name.to_s, attribute.name)
      assert_equal(@kwargs[name], attribute.default.call)
    end
  end

  def test_fattr_with_default_block
    parsed = ::Fattr::AttributeParser.call([:a], {}, @block)
    assert_equal(1, parsed.size)

    p = parsed.first
    assert_equal("a", p.name)
    assert_equal(42, p.default.call)
  end

  def test_error_with_both_block_and_default_value
    assert_raises(::Fattr::InvalidAttributeError) {
      ::Fattr::AttributeParser.call([], @kwargs, @block)
    }
  end

  def test_error_with_both_block_and_list_of_params
    assert_raises(::Fattr::InvalidAttributeError) {
      ::Fattr::AttributeParser.call(@args, {}, @block)
    }
  end

  def test_error_with_attribute_list_some_defaults_and_default_fattr
    kw = @kwargs.merge(:default => "wibble")
    assert_raises(::Fattr::InvalidAttributeError) {
      ::Fattr::AttributeParser.call(@args, kw)
    }
  end

  def test_error_with_attribute_list_some_defaults_and_inheritable_fattr
    kw = @kwargs.merge(:inheritable => "wibble")
    assert_raises(::Fattr::InvalidAttributeError) {
      ::Fattr::AttributeParser.call(@args, kw)
    }
  end

  def test_error_with_fattr_having_default_and_block
    assert_raises(::Fattr::InvalidAttributeError) {
      ::Fattr::AttributeParser.call([], { :a => 99 }, @block)
    }
  end
end
