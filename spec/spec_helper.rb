require "rubygems"
require "bundler/setup"
require "rspec"
require "active_support"
require "timecop"

require "burlap"

# element_exists_with :selector => "map", :count => 1
def element_exists_with opts={}
  elements = @doc.css(opts[:selector])
  elements.should have(opts[:count]).elements
  elements
end
