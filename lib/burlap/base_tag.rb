module Burlap

  class BaseTag
    def self.mappings
      @@mappings ||= {}
    end

    attr_accessor :text, :children

    def initialize
      self.children = []
    end

    def to_ruby
      raise "Unimplemented: #{self.class}#to_ruby on #{self.inspect}"
    end

    def self.tag_name *names
      names.each do |name|
        BaseTag.mappings[name] = self
      end
    end
  end

  # Root element of the replies
  class BurlapReply < BaseTag
    tag_name "burlap:reply"

    def to_ruby
      children.first.to_ruby if children.first
    end
  end

  # This is here to "fill in" for unknown mappings
  class Object
    attr_accessor :contents, :type

    def initialize opts={}
      opts.each do |key, value|
        setter = :"#{key}="
        send(setter, value) if respond_to?(setter)
      end
    end

    def to_ruby
      self
    end
  end

  # Wraps up all child elements into a type. There are a couple
  # of native types specified, BigDecimal and Timestamp.
  class Map < BaseTag
    tag_name "map"

    attr_accessor :type, :contents

    def self.mappers
      @@mappers ||= ::Hash.new(Burlap::Object)
    end

    def self.handle_mapping name
      mappers[name] = self
    end

    def to_ruby
      # Pop the first element off
      t = children.shift.to_ruby

      # And then the rest are matched pairs
      dict = {}

      children.each_slice(2) do |arr|
        key, value = arr.map(&:to_ruby)
        dict[key] = value
      end

      klass = Map.mappers[t]
      m = klass.new
      m.contents = dict
      m.type = t
      m.to_ruby
    end

    class Timestamp < Map
      handle_mapping "java.sql.Timestamp"

      def to_ruby
        # This is already parsed as a Time object
        contents["value"]
      end
    end

    require "bigdecimal"
    class BigDecimal < Map
      handle_mapping "java.math.BigDecimal"

      def to_ruby
        ::BigDecimal.new(contents["value"])
      end
    end
  end

  # Type is also just a string
  class String < BaseTag
    tag_name "string", "type"

    def to_ruby
      text || ""
    end
  end

  # Length is an integer as well
  class Int < BaseTag
    tag_name "int", "length", "ref"

    def to_ruby
      text.to_i
    end
  end

  # Null is nil
  class Null < BaseTag
    tag_name "null"

    def to_ruby
      nil
    end
  end

  require "time"
  class Date < BaseTag
    tag_name "date"

    def to_ruby
      ::Time.parse(text)  if text
    end
  end

  class List < BaseTag
    tag_name "list"

    def to_ruby
      t = children.shift.to_ruby
      length = children.shift.to_ruby

      dict = {}

      children.each_slice(2) do |arr|
        key, value = arr.map(&:to_ruby)
        dict[key] = value
      end

      obj = Burlap::Object.new
      obj.contents = dict
      obj.type = t
      obj
    end
  end

  class Error < Burlap::Object
    attr_reader :code, :message, :detail_message, :stack_trace, :cause

    def initialize opts={}
      data = opts[:contents]

      @message = data["message"]
      @code = data["code"]
      detail = data["detail"].contents
      @detail_message = detail["detailMessage"]
      @stack_trace = detail["stackTrace"]
      @cause = detail["cause"]

      @contents = nil
    end
  end

  class Fault < BaseTag
    tag_name "fault"

    def to_ruby
      dict = {}

      children.each_slice(2) do |arr|
        key, value = arr.map(&:to_ruby)
        dict[key] = value
      end

      Error.new(:contents => dict)
    end
  end

end
