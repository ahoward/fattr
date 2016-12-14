require 'forwardable'
require 'fattr/attribute'

module Fattr
  #
  # A unique bag of tokens that is the attribute list of the Fattr
  #
  class AttributeSet
    include Enumerable
    extend Forwardable

    def initialize
      @set = Hash.new
    end

    def <<(attribute)
      @set[attribute.name] = attribute
      return self
    end

    def each
      if block_given? then
        @set.values.each do |attr|
          yield attr.name
        end
      else
        @set.values.map {|v| v.name }.each
      end
    end

    def include?(attribute)
      key = attribute.instance_of?(::Fattr::Attribute) ? attribute.name : attribute.to_s
      @set.include?(key)
    end
  end
end
