require 'test_helper'
require 'fattr/globally'

class TestFattr < ::Minitest::Test

  def test_a_basic_set_of_methods_are_defined
    o = Class.new{ fattr :a }.new
    %w( a a= a? ).each do |msg|
      assert_respond_to(o, msg)
    end
  end


  def test_the_basic_usage
    o = Class.new{ fattr :a }.new
    assert_nil(o.a)

    o.a = 42
    assert_equal(42, o.a)

    o.a(42.0)
    assert_equal(42.0, o.a)

    assert(o.a?)
  end

  def test_simple_default
    o = Class.new{
      fattr :a => 42
    }.new

    assert_equal(42, o.a)
  end

  def test_block_defaults
    n = 41
    o = Class.new{ fattr(:a){ n += 1 } }.new
    assert_equal(42, o.a)
    assert_equal(42, n)

    o2 = Class.new{ fattr(:a) { n += 1 } } .new
    assert_equal(43, o2.a)
    assert_equal(43, n)
  end

  def test_more_than_one_fattrs_may_be_defined_at_once
    o = Class.new{
      fattr :a, :b
    }.new

    %w( a a= a? b b= b? ).each do |msg|
      assert_respond_to(o, msg)
    end
  end

  def test_more_than_one_fattrs_with_defaults_may_be_defined_at_once
    o = Class.new{ fattr :a => 40, :b => 2 }.new
    assert_equal(40, o.a)
    assert_equal(2, o.b)
  end

  def test_fattrs_may_be_retrieved_from_the_object
    c = Class.new{ fattr :a, :b, :c; self }

    assert_equal(%w[ a b c ], c.fattrs.sort)
  end

  def test_getters_as_setters
    o = Class.new{ fattr :a }.new
    assert_nil(o.a)
    o.a(42)

    assert_equal(42, o.a)
  end

  def test_module_fattrs
    m = Module.new{ class << self; fattr :a => 42; end; }
    assert_equal(42, m.a)
  end

  def test_a_list_of_fattrs_may_be_declared_at_once 
    list = %w( a b c )
    c = Class.new{ fattrs list }
    list.each do |attr|
      assert_includes(c.fattrs, attr.to_s)
      assert_includes(c.fattrs, attr.to_sym)
    end
  end

  def test_all_fattrs_can_be_retireved_via_to_hash
    c = Class.new{ fattr :a; fattr :b; fattr(:c){ 'forty-two' } }
    o = c.new
    o.a = 42
    o.b = 42.0
    hash = o.fattrs.to_hash
    assert_equal(42, hash['a'])
    assert_equal(42.0, hash['b'])
    assert_equal('forty-two', hash['c'])
  end

  def test_all_fattrs_are_inherited_in_child_classes
    c = Class.new{
      fattr :a
      fattr :b
      fattr(:c) { 'forty-two' }
    }

    d = Class.new(c)

    od   = d.new
    od.a = 42
    od.b = 42.0

    assert_equal(42, od.a)
    assert_equal(42.0, od.b)
    assert_equal('forty-two', od.c)
  end

  def test_make_sure_that_each_instance_has_its_own_copy_of_the_variables
    c = Class.new{ fattr :a }
    o1 = c.new
    o1.a = 42
    assert_equal(42, o1.a)

    o2 = c.new
    o2.a = 55
    assert_equal(55, o2.a)
    assert_equal(42, o1.a)
  end

  def test_ensure_that_initialization_bocks_are_executed_in_the_context_of_the_instance
    c = Class.new{
      fattr :a => 42
      fattr(:b) { "#{a}-b" }
      fattr :c => lambda { "#{a}-c" }
    }

    o = c.new
    assert_equal("42-b", o.b)
    o.a = 99
    assert_equal("99-c", o.c)
  end

  def test_class_fattr_shortcut
    c = Class.new{
      Fattr :a => 42
    }
    assert_equal(42, c.a)
  end

  def test_module_fattr_shortcut
    m = Module.new{
      Fattr :a => 42
    }
    assert_equal(42, m.a)
  end

  def test_fattrs_support_class_inheritable_attributes
    a = Class.new{ Fattr :x, :default => 42, :inheritable => true }
    b = Class.new(a)
    c = Class.new(b)

    def a.name() 'a' end
    def b.name() 'b' end
    def c.name() 'c' end

    assert_equal(42, c.x)
    assert_equal(42, b.x)
    assert_equal(42, a.x)

    b.x = 42.0
    assert_equal(42.0, b.x)
    assert_equal(42, a.x)

    a.x = 'forty-two'
    assert_equal('forty-two', a.x)
    assert_equal(42.0, b.x)

    b.x!
    assert_equal('forty-two', b.x)

    b.x = "FORTY-TWO"

    c.x!
    assert_equal('FORTY-TWO', c.x)
  end
end
