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

      convert_hex_entities_to_decimal root.to_xml(nokogiri_xml_options)
    end

  protected
    def nokogiri_xml_options
      {:indent => 0, :indent_text => "", :save_with => Nokogiri::XML::Node::SaveOptions::AS_HTML}
    end

    # Converts all hex entities into decimal entities.
    # 
    # eg: &#xE5; into &#229;
    # 
    # @param [String, #gsub] string string to convert entities in
    # @return [String] string with decimal entities
    def convert_hex_entities_to_decimal string
      string.gsub(/&#x[0-9a-f]+;/i) do |match|
        # Extract the hex value and convert to decimal
        dec = match[/x([0-9a-f]+;)/i, 1].to_i(16)

        "&##{dec};"
      end
    end
  end
end
