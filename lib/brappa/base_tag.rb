module Brappa

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

  # Wraps up all child elements into a type. There are a couple
  # of native types specified, BigDecimal and Timestamp.
  class Map < BaseTag
    tag_name "map"

    attr_accessor :type, :contents

    def self.mappers
      @@mappers ||= {}
    end

    def self.handle_mapping name
      mappers[name] = self
    end

    def to_map
      self
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

      klass = Map.mappers[t] || Map
      m = klass.new
      m.contents = dict
      m.type = t
      m.to_map
    end

    class Timestamp < Map
      handle_mapping "java.sql.Timestamp"

      def to_map
        contents["value"]
      end
    end

    require "bigdecimal"
    class BigDecimal < Map
      handle_mapping "java.math.BigDecimal"

      def to_map
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
    tag_name "int", "length"

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

  require "date"
  class Date < BaseTag
    tag_name "date"

    def to_ruby
      ::Date.parse(text) if text
    end
  end

  class List < BaseTag
    tag_name "list"

    def to_ruby
      # todo: implement
      "<< list >>"
    end
  end

end
