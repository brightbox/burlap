require "active_support/ordered_hash"

module Burlap
  # todo: subclass ::Hash once this is 1.9.2 only
  class Hash < ActiveSupport::OrderedHash
    attr_writer :__type__

    # We override this to allow a type to be set upon object initialization.
    # As we subclass Hash and call super it should behave exactly the same
    # as Hash#[].
    #
    # NB: we actually subclass ActiveSupport::OrderedHash for ordered hash support
    # in ruby 1.8.x, which means we don't behave exactly like Hash#[] on 1.8.x. Sucks.
    #
    # Examples:
    #
    #   Burlap::Hash[:one => :two] # => {:one => :two}, type == ""
    #   Burlap::Hash[{:one => :two}, "fred"] # => {:one => :two}, type == "fred"
    #
    def self.[] *args
      if args.size == 2 && args[1].is_a?(::String)
        h = super(args[0].to_a)
        h.__type__ = args[1]
        h
      elsif args.size == 1 && args[0].is_a?(::Hash)
        super(args[0].to_a)
      else
        super
      end
    end

    # Accessor for the type attribute, defaults to an empty string
    def __type__
      @__type__ ||= ""
    end

    # Build a string for ourselves, including both __type__ and the hash
    def inspect
      "#<#{self.class} __type__=#{__type__} #{to_h.inspect}>"
    end

    # Return ourselves as a plain old ruby Hash
    def to_h
      ::Hash[self]
    end

    # Converts the hash into a string of XML, calling #to_burlap on all keys &
    # values. Builds a <map> element, with type set then all key/values following.
    def to_burlap
      # Build the node for the type
      contents = [Burlap::Node.new(
        :name => "type",
        :value => self.__type__
      )]

      # Build nodes for all the content
      contents += self.map do |k,v|
        [
          Burlap::Node.new(:name => "string", :value => k),
          Burlap::Node.new(:name => "string", :value => v)
        ]
      end.flatten

      content = contents.map(&:to_burlap).join("")

      Burlap::Node.new(
        :name => "map",
        :value => content
      ).to_burlap
    end

  end
end
