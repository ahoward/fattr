require 'simplecov'
if ENV['COVERAGE'] then
  SimpleCov.start do
    add_filter "/.gem/"
  end
end
gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
