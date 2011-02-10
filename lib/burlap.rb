# burlap/version already got included by gemspec
require "burlap/error"
require "burlap/array"
require "burlap/hash"

require "burlap/node"
require "burlap/emit"
require "burlap/core_ext" # todo: make optional?
require "burlap/base_tag"

require "burlap/call"
require "burlap/listener"

module Burlap

  def self.parse io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)
    parser.parse(io_handle)
    listener.result
  end

  def self.dump obj
    if obj.respond_to?(:to_burlap)
      obj.to_burlap
    else
      raise Error, "couldn't dump #{obj.inspect}"
    end
  end

end
