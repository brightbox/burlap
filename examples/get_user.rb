require "rubygems"
require "bundler/setup"
require "burlap"
require "pp"

datafile = File.new("getUserWs.xml")
pp Burlap.parse(datafile)
