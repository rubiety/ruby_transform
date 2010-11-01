require "rubygems"
require "active_support"
require "ruby_parser"
require "ruby_scribe"

Dir[File.join(File.dirname(__FILE__), "ruby_transform/**/**/*.rb")].each do |file|
  require file
end
