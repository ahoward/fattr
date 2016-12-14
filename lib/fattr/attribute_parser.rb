module Fattr
  class InvalidAttributeError < ::StandardError
  end
  #
  # parse the attributes given to fattr, or Fattr methods and return an array of
  # Attribute instances. 
  #
  # Styles we have to parse
  #
  # * :x => 42, :y => lambda { "42" }
  # * :x, :default => 42, :inheritable => true
  # * :x, :y, :z
  # * (:x, :inheritable => true) { "42" }
  #
  module AttributeParser
    #
    #
    def self.call(args, kwargs, block)
      return [] if args.empty? && kwargs.empty?

      # fattr [:a, :b, :c]
      if args.size == 1 && args.first.kind_of?(Array) then
        args = *(args.first)
      end

      # fattr :x, :default => 42, :inheritable => true
      # fattr(:x, :inheritable => true) { "42" }
      # fattr(:x) { 42 }
      if args.size == 1 then
        return attributes_from_full_params(args, kwargs, block)
      end

      # fattr :x => 42, :y => lambda { "42" }
      # :x, :y, :z
      # :a, :b, :c, :foo => "wibble", :bar => "baz"
      if only_attributes_with_defaults?(args, kwargs, block) ||
          only_named_attributes?(args, kwargs, block) ||
          named_attributes_some_with_defaults(args, kwargs, block) then
        return attributes_from_args_and_kwargs(args, kwargs)
      end

      block_msg = block ? "with" : "without"
      raise ArgumentError, "Unable to parse (#{args.inspect}, #{kwargs.inspect}) #{block_msg} a block"
    end

    def self.only_attributes_with_defaults?(args, kwargs, block)
      raise InvalidAttributeError, "Cannot have both block and a default value" if block && kwargs.any?
      args.empty? && kwargs.any?
    end

    def self.only_named_attributes?(args, kwargs, block)
      raise InvalidAttributeError, "Cannot have a default block with a list of attributes" if block && (args.size > 1)
      args.any? && kwargs.empty?
    end

    def self.named_attributes_some_with_defaults?(args, kwargs, block)
      if (args.size > 1) && kwargs.any? then
        raise InvalidAttributeError, "Cannot have a list of attributes AND an attribute :default with a default value"     if kwargs.has_key?(:default)
        raise InvalidAttributeError, "Cannot have a list of attributes AND an attribute :inheritable with a default value" if kwargs.has_key?(:inheritable)
        raise InvalidAttributeError, "Cannot ahve a list of attributes and a default block" if block
        true
      else
        false
      end
    end

    def self.attributes_from_args_and_kwargs(args, kwargs)
      Array.new.tap do |attributes|
        args.each do |name|
          attributes << Attribute.new(name)
        end

        kwargs.each do |name, default|
          attributes << Attribute.new(name, default: default)
        end
      end
    end

    def self.attributes_from_full_params(args, kwargs, block)
      raise InvalidAttributeError, "Cannot have a default block and a default value for #{args.first}" if kwargs.has_key?(:default) && block
      default = kwargs.fetch(:default, block)
      [ Attribute.new(args.first, default: default, inheritable: kwargs[:inheritable]) ]
    end

  end
end
