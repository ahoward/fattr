#
# you can add class/module fattrs the 'normal' way or using the provided
# shortcut method
#
  require 'fattr'

  class C
    class << self
      fattr 'a' => 4
    end

    Fattr 'b' => 2
  end

  p [ C.a, C.b ].join
