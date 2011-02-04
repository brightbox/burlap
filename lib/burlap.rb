# burlap/version already got included by gemspec
require "burlap/error"
require "burlap/hash"

require "burlap/emit"
require "burlap/core_ext" # todo: make optional?
require "burlap/base_tag"

require "burlap/generator"
require "burlap/call"
require "burlap/listener"

module Burlap

  def self.parse io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)
    parser.parse(io_handle)
    listener.result
  end

end
