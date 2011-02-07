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
    def to_burlap doc=nil
      doc ||= Nokogiri::XML::Document.new
      root = Nokogiri::XML::Node.new self.name.to_s, doc

      # Would like to use respond_to?(:each), but String implements that
      # and we don't want to call String#each
      if self.contents.is_a?(Array)
        self.contents.each do |arg|
          root << arg.to_xml(doc)
        end
      else
        # Use it as this node's content
        root.content = self.contents
      end

      root.to_xml
    end
    alias_method :to_xml, :to_burlap

  end
end
