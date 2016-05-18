require 'set'
require 'forwardable'

module Fattr
  class Attributes
    include Enumerable
    extend Forwardable

    def_delegator :@list, :each

    def initialize
      @list = Set.new
    end

    def <<(name)
      @list << name.to_s
    end

    def include?(other)
      @list.include?(other.to_s)
    end

  end
end
