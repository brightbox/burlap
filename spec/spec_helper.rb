require "rubygems"
require "bundler/setup"
require "rspec"
require "active_support"
require "active_support/core_ext/hash/except"
require "timecop"

require "burlap"

# element_exists_with :selector => "map", :count => 1
def element_exists_with opts={}
  elements = @doc.css(opts[:selector])
  elements.size.should eq(opts[:count])
  elements
end
