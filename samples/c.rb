#
# multiple values may by given, plain names and key/val pairs may be mixed.
#
  require 'fattr'

  class C
    fattrs 'x', 'y' => 0b101000, 'z' => 0b10
  end

  c = C.new
  c.x = c.y + c.z
  p c.x #=> 42
