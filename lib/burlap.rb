module Burlap

  # Stores the resolver object for parsing burlap
  class << self
    attr_accessor :resolver
  end

  # Turns a burlap string read from `io_handle` into native
  # ruby objects.
  def self.parse io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)
    parser.parse(io_handle.encode!(Encoding::UTF_8))
    listener.result
  end

  # Turns `obj` into a burlap XML representation
  def self.dump obj
    if obj.respond_to?(:to_burlap)
      obj.to_burlap
    else
      raise Error, "couldn't dump #{obj.inspect}"
    end
  end

end

require "base64"
require "erb"
require "core_ext/time_burlap_iso8601"

require "burlap/default_resolver"
# burlap/version already got included by gemspec
require "burlap/error"
require "burlap/array"
require "burlap/hash"

require "burlap/node"
require "burlap/core_ext" # todo: make optional?
require "burlap/base_tag"
require "burlap/fault"

require "burlap/call"
require "burlap/listener"
