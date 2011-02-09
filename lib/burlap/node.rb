module Burlap
  class Node
    attr_accessor :name, :contents

    # name is the element name to go in the <>
    # and content is either an array of nested nodes, or a string to be the node content
    def initialize params={}
      params.each do |k,v|
        meffod = :"#{k}="
        send(meffod, v) if respond_to?(meffod)
      end
    end

    # Packs this object into nokogiri nodes and returns the XML as a string
    def to_burlap
      doc = Nokogiri::XML::Document.new
      root = Nokogiri::XML::Node.new(self.name, doc)
      # Would like to use respond_to?(:each), but String implements that
      # and we don't want to call String#each
      if self.contents.is_a?(Array)
        root << self.contents.to_burlap
      else
        # Use it as this node's content
        self.contents = self.contents
      end

    end

  end
end
