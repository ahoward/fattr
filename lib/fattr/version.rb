module Fattr
  Version = '3.0.0' unless Fattr.const_defined?(:Version)
  def self.version
    Fattr::Version
  end
end
