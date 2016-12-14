# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "fattr"
This.author   = "Ara T. Howard"
This.email    = "ara.t.howard@gmail.com"
This.homepage = "http://github.com/ahoward/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_development_dependency( 'rake'     , '~> 10.3')
  spec.add_development_dependency( 'minitest' , '~> 5.7' )
  spec.add_development_dependency( 'rdoc'     , '~> 4.1' )
  spec.add_development_dependency( 'simplecov', '~> 0.10')
end

load 'tasks/default.rake'
