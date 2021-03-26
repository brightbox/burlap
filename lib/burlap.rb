module Burlap
  # Regexp from https://www.johnhawthorn.com/2009/10/sanitizing-utf8-in-ruby/
  SANITIZE_ASCII_UTF8_REGEX = /\A(
    [\x09\x0A\x0D\x20-\x7E]            # ASCII
    | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
    |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
    | [\xE1-\xEC\xEE][\x80-\xBF]{2}      # straight 3-byte
    |  \xEF[\x80-\xBE]{2}                # 
    |  \xEF\xBF[\x80-\xBD]               # excluding U+fffe and U+ffff
    |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
    |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
    | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
    |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
  )*\Z/nx;

  # Stores the resolver object for parsing burlap
  class << self
    attr_accessor :resolver
  end

  # Turns a burlap string read from `io_handle` into native
  # ruby objects.
  def self.parse io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)

    if io_handle.encoding == Encoding::ASCII_8BIT
      io_handle = sanitize_ascii(io_handle)
      io_handle.encode!(Encoding::UTF_8)
    elsif io_handle.encoding == Encoding::ISO_8859_1
      io_handle.encode!(Encoding::UTF_8)
    end

    parser.parse(io_handle)
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

  def self.sanitize_ascii(input)
    input.split(//).grep(SANITIZE_ASCII_UTF8_REGEX).join
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
