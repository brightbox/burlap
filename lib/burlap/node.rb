module Burlap
  class Node
    attr_accessor :name, :value

    # name is the element name to go in the <>
    # and value is a string to go in the node
    def initialize params={}
      params.each do |k,v|
        meffod = :"#{k}="
        send(meffod, v) #if respond_to?(meffod)
      end
    end

    # Packs this object into nokogiri nodes and returns the XML as a string
    def to_burlap
      doc = Nokogiri::XML::Document.new
      root = Nokogiri::XML::Node.new(self.name, doc)

      if self.value.to_s == ""
        root.children = self.value.to_s
      else
        root << self.value.to_s
      end

      root.to_xml(:indent => 0, :indent_text => "", :save_with => Nokogiri::XML::Node::SaveOptions::AS_HTML)
    end

  end
end
