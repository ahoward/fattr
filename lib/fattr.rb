module Fattr
  Fattr::VERSION = '1.1.0' unless Fattr.const_defined?(:VERSION)
  def self.version() Fattr::VERSION end

  class List < ::Array
    def << element
      super
      self
    ensure
      uniq!
      index!
    end

    def index!
      @index ||= Hash.new
      each{|element| @index[element] = true}
    end

    def include? element
      @index ||= Hash.new
      @index[element] ? true : false
    end

    def initializers
      @initializers ||= Hash.new
    end
  end

  def fattrs *a, &b
    unless a.empty?
      returned = Hash.new

      hashes, names = a.partition{|x| Hash === x}
      names_and_defaults = {}
      hashes.each{|h| names_and_defaults.update h}
      names.flatten.compact.each{|name| names_and_defaults.update name => nil}

      initializers = __fattrs__.initializers

      names_and_defaults.each do |name, default|
        raise NameError, "bad instance variable name '@#{ name }'" if "@#{ name }" =~ %r/[!?=]$/o
        name = name.to_s

        initialize = b || lambda { default }
        initializer = lambda do |this|
          Object.instance_method('instance_eval').bind(this).call &initialize
        end
        initializer_id = initializer.object_id
        __fattrs__.initializers[name] = initializer

        compile = lambda do |code|
          begin
            module_eval code
          rescue SyntaxError
            raise SyntaxError, "\n#{ code }\n"
          end
        end

      # setter, block invocation caches block
        code = <<-code
          def #{ name }=(*value, &block)
            value.unshift block if block
            @#{ name } = value.first
          end
        code
        compile[code]

      # getter, providing a value or block causes it to acts as setter
        code = <<-code
          def #{ name }(*value, &block)
            value.unshift block if block
            return self.send('#{ name }=', value.first) unless value.empty?
            #{ name }! unless defined? @#{ name }
            @#{ name }
          end
        code
        compile[code]

      # bang method re-calls any initializer given at declaration time
        code = <<-code
          def #{ name }!
            initializer = ObjectSpace._id2ref #{ initializer_id }
            self.#{ name } = initializer.call(self)
            @#{ name }
          end
        code
        compile[code]

      # query simply defers to getter - cast to bool
        code = <<-code
          def #{ name }?
            self.#{ name }
          end
        code
        compile[code]

        fattrs << name
        returned[name] = initializer 
      end

      returned
    else
      begin
        __fattr_list__
      rescue NameError
        singleton_class =
          class << self
            self
          end
        klass = self
        singleton_class.module_eval do
          fattr_list = List.new 
          define_method('fattr_list'){ klass == self ? fattr_list : raise(NameError) }
          alias_method '__fattr_list__', 'fattr_list'
        end
        __fattr_list__
      end
    end
  end

  %w( __fattrs__ __fattr__ fattr ).each{|dst| alias_method dst, 'fattrs'}
end

class Module
  include Fattr

  def Fattrs(*a, &b)
    class << self
      self
    end.module_eval do
      fattrs(*a, &b)
    end
  end

  def Fattr(*a, &b)
    class << self
      self
    end.module_eval do
      fattr(*a, &b)
    end
  end
end

class Object
  def fattrs *a, &b
    sc = 
      class << self
        self
      end
    sc.fattrs *a, &b
  end
  %w( __fattrs__ __fattr__ fattr ).each{|dst| alias_method dst, 'fattrs'}
end
