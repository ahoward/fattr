
module Fattr
  class Attribute
    attr_reader :name
    attr_reader :default
    attr_reader :inheritable

    def initialize(name, default: nil, inheritable: false)
      @name = name.to_s
      @default = initializer_from(default)
      @inheritable = inheritable
    end

    def inheritable?
      !!@inheritable
    end

    private

    def initializer_from(thing)
      if thing.kind_of?(Proc)
        thing
      else
        lambda{ |*args| thing }
      end
    end
  end
end
