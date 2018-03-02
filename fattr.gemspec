## fattr.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "fattr"
  spec.version = "2.4.0"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "fattr"
  spec.description = "a \"fatter attr\" for ruby"
  spec.license = "Ruby"

  spec.files =
["LICENSE",
 "README",
 "README.erb",
 "Rakefile",
 "fattr.gemspec",
 "lib",
 "lib/fattr",
 "lib/fattr.rb",
 "lib/fattr/_lib.rb",
 "lib/fattr/version.rb",
 "samples",
 "samples/a.rb",
 "samples/b.rb",
 "samples/c.rb",
 "samples/d.rb",
 "samples/e.rb",
 "samples/f.rb",
 "samples/g.rb",
 "samples/h.rb",
 "samples/i.rb",
 "test",
 "test/fattr_test.rb"]

  spec.executables = []
  
  spec.require_path = "lib"

  spec.test_files = nil

  

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/fattr"
end
