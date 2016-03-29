#
# you can retrieve all fattrs as a list, or a hash with values included
#
  require 'fattr'

  class C
    fattr(:a)
    fattr(:b){ a.to_f }
  end

  o = C.new

  o.fattr(:c)
  o.fattr(:d){ self.c.upcase }

  o.a = 42
  o.c = 'forty-two' 

  p o.fattrs.to_hash #=> {"a"=>42, "b"=>42.0, "c"=>"forty-two", "d"=>"FORTY-TWO"}
  p o.fattrs         #=> ["c", "d"]
