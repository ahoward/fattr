## fattr.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "fattr"
  spec.version = "2.2.2"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "fattr"
  spec.description = "a \"fatter attr\" for ruby"
  spec.license = "same as ruby's"

  spec.files =
["LICENSE",
 "README",
 "README.erb",
 "Rakefile",
 "lib",
 "lib/fattr.rb",
 "samples",
 "samples/a.rb",
 "samples/b.rb",
 "samples/c.rb",
 "samples/d.rb",
 "samples/e.rb",
 "samples/f.rb",
 "samples/g.rb",
 "samples/h.rb",
 "test",
 "test/fattr_test.rb"]

  spec.executables = []
  
  spec.require_path = "lib"

  spec.test_files = nil

### spec.add_dependency 'lib', '>= version'
#### spec.add_dependency 'map'

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/fattr"
end
