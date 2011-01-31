module Burlap

  def self.parse io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)
    parser.parse(io_handle)
    listener.result
  end

  def self.dump object
    Generator.new(object).dump
  end

end

# burlap/version already got included by gemspec
require "burlap/listener"
require "burlap/base_tag"
require "burlap/generator"
