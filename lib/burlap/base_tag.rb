module Burlap

  class BaseTag
    attr_accessor :name, :value, :children

    def initialize params={}
      params.each do |k,v|
        meffod = :"#{k}="
        send(meffod, v) if respond_to?(meffod)
      end
    end

    def children
      @children ||= []
    end

    def value
      @value ||= ""
    end

    def parse_matched_pairs
      # The children are matched pairs.
      # We use an array here because ruby 1.8.x is _FUN_ to
      # use ordered hashes with and doing it in an array is
      # easier for now. Viva la 1.9!
      values = []

      self.children.each_slice(2) do |arr|
        key = arr.first.to_ruby
        value = if arr.last.name == "ref"
          i = arr.last.value.to_i - 1
          v = values[i]
          v.last if v
        else
          arr.last.to_ruby
        end

        values << [key, value]
      end

      values
    end

    def to_ruby
      Burlap.resolver.convert_to_native self
    end

  end

end

__END__

# todo: introduce into resolver block for map
class Timestamp < Map
  handle_mapping "java.sql.Timestamp"

  def to_ruby
    # This is already parsed as a Time object
    contents["value"]
  end
end

# todo: introduce into resolver block for map
require "bigdecimal"
class BigDecimal < Map
  handle_mapping "java.math.BigDecimal"

  def to_ruby
    ::BigDecimal.new(contents["value"])
  end
end
end

# todo: add a resolver block to parse this out
class Fault
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

# todo: add a resolver block for this logic
class FaultTag < BaseTag
  def to_ruby
    dict = {}

    children.each_slice(2) do |arr|
      key, value = arr.map(&:to_ruby)
      dict[key] = value
    end

    Fault.new(:contents => dict)
  end
end
