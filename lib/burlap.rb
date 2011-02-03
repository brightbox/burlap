# burlap/version already got included by gemspec
require "burlap/listener"
require "burlap/base_tag"
require "burlap/call"

module Burlap

  def self.parse io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)
    parser.parse(io_handle)
    listener.result
  end

end
