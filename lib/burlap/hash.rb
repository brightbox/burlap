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
      @__type__ ||= ""
    end

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
