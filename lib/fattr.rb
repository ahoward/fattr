require 'fattr/attribute_set'
require 'fattr/attribute'
require 'fattr/attribute_parser'

module Fattr
  # How we get this thing all going
  #
  def self.extended(other)
    other.include(InstanceMethods)
  end

  def self.included(other)
    other.include(InstanceMethods)
  end

  def fattr(*args, **kwargs, &block)
    attributes = AttributeParser.call(args, kwargs, block)
    __define_attributes(attributes)
  end
  alias fattrs fattr

  def Fattr(*args, **kwargs, &block)
    attributes = AttributeParser.call(args, kwargs, block)
    singleton_class.instance_exec do
      __define_attributes(attributes)
    end
  end
  module_function :Fattr

  module InstanceMethods
    def fattrs
      Hash.new.tap do |h|
        self.class.fattrs.each do |name|
          h[name] = self.send(name)
        end
      end
    end
  end

  private

  def __define_attributes(attributes)
    attributes.each do |attr|
      __define_fattr(attr)
    end
    __fattrs
  end

  def __define_fattr(attr)
    __fattrs << attr
    __define_reader(attr)
    __define_writer(attr)
    __define_question(attr)
    __define_bang(attr)
  end

  def __define_reader(attr)
    name = attr.name
    varname = "@#{name}"
    define_method(name.to_sym) do |*args|
      if value = args.shift then
        instance_variable_set(varname, value)
      elsif instance_variable_defined?(varname)
        instance_variable_get(varname)
      else
        # we want the lambda to be executed within the context of self
        value = instance_exec(&attr.default)
        instance_variable_set(varname, value)
      end
    end
  end

  def __define_writer(attr)
    define_method("#{attr.name}=") do |arg|
      instance_variable_set("@#{attr.name}", arg)
    end
  end

  def __define_question(attr)
    define_method("#{attr.name}?") do
      !!instance_variable_get("@#{attr.name}")
    end
  end

  def __define_bang(attr)
    define_method("#{attr.name}!") do
      value = instance_exec(&attr.default)
      if attr.inheritable? then
        parent = ancestors[1..-1].find { |a| a.respond_to?(attr.name) }
        value = parent.send(attr.name) if parent
      end
      instance_variable_set("@#{attr.name}", value)
    end
  end

  def __fattrs
    @__fattrs ||= AttributeSet.new
  end
end
require 'fattr/version'
