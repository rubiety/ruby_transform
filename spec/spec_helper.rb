$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require "rubygems"
require "rspec"
require "ruby_transform"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/matchers/**/*.rb"].each {|f| require f}
