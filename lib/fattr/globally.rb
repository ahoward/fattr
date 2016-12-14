require 'fattr'
class Object
  extend Fattr
end

class Module
  include Fattr
end
