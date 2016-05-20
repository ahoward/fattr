require 'fattr/attributes'
module Fattr
  # How we get this thing all going
  #
  def self.extended(other)
    other.include(InstanceMethods)
  end

  # def self.included(other)
  #   other.include(InstanceMethods)
  #   other.extend(ClassMethods)
  # end

  def fattr(*attributes, &block)
    __define_attributes(attributes: attributes, default: block)
  end
  alias fattrs fattr

  def Fattr(*attributes, &block)
    singleton_class.instance_exec do
      __define_attributes(attributes: attributes, default: block)
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

  def __initializer_from(thing)
    if thing.kind_of?(Proc)
      thing
    else
      lambda{ |*args| thing }
    end
  end

  def __define_attributes(attributes:, default:)
    attributes.flatten.each do |arg|
      case arg
      when Symbol, String
        __define_fattr(arg, __initializer_from(default))
      when Hash
        arg.each_pair do |key, val|
          __define_fattr(key, __initializer_from(val))
        end
      else
        raise ArgumentError, "No idea how to deal with a #{arg.inspect}"
      end
    end
    __fattrs
  end

  def __define_fattr(name, default_lambda)
    __fattrs << name.to_s
    __define_reader(name, default_lambda)
    __define_writer(name)
    __define_question(name)
  end

  def __define_reader(name, default)
    varname = "@#{name}"
    define_method(name.to_sym) do |*args|
      if value = args.shift then
        instance_variable_set(varname, value)
      elsif instance_variable_defined?(varname)
        instance_variable_get(varname)
      else
        # we want the lambda to be executed within the context of self
        value = instance_exec(&default)
        instance_variable_set(varname, value)
      end
    end
  end

  def __define_writer(name)
    define_method("#{name}=") do |arg|
      instance_variable_set("@#{name}", arg)
    end
  end

  def __define_question(name)
    define_method("#{name}?") do
      !!instance_variable_get("@#{name}")
    end
  end

  def __fattrs
    @__fattrs ||= Attributes.new
  end
end
require 'fattr/version'
