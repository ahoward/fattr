module Fattr
  Fattr::Version = '2.4.0' unless Fattr.const_defined?(:Version)

  def Fattr.version() Fattr::Version end

  def Fattr.description
    'a "fatter attr" for ruby'
  end
end
