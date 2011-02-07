require "rubygems"
require "nokogiri"

module Burlap
  class Hash < ::Hash
    attr_writer :__type__

    def self.[] *args
      if args.size == 2 && args[1].is_a?(::String)
        h = super(args[0])
        h.__type__ = args[1]
        h
      else
        super
      end
    end

    def __type__
      @__type__ ||= "Hash"
    end

    def to_burlap
      # Build the node for the type
      type = Burlap::Node.new(
        :name => "type",
        :contents => self.__type__
      )

      # Build nodes for all the content
      content = self.map do |k,v|
        [Burlap::Node.new(:name => "string", :contents => k), Burlap::Node.new(:name => "string", :contents => v)]
      end.flatten

      Burlap::Node.new(
        :name => "map",
        :contents => [type, *content]
      ).to_xml
    end

  end
end
