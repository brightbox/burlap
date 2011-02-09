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

      p self.value
      root.content = self.value.to_s

      root.to_xml
    end

  end
end
