require "rubygems"
require "bundler/setup"
require "burlap"
require "pp"

file = File.expand_path("getUserWs.xml", File.dirname(__FILE__))
datafile = File.new(file)
pp Burlap.parse(datafile)
