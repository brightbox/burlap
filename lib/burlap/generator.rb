module Burlap
  class Generator
    GeneratorError = Class.new(Burlap::Error)

    attr_reader :root, :data

    def initialize data
      raise ArgumentError, "data is not a Hash" unless data.is_a?(::Hash)
      raise ArgumentError, "data can only contain one root element" if data.keys.size > 1
      self.root = data.keys.first
      self.data = data[root]
    end

    def to_xml
      nx = Nokogiri::XML
      doc = nx::Document.new
      root_node = nx::Node.new(root, doc)
      doc.add_child root_node

      data.each do |e|
        raise GeneratorError, "Couldn't generate burlap for #{e.class.to_s} #{e.inspect}. Please mix in Burlap::Emit for support or implement :burlap_node" unless e.respond_to?(:burlap_node)

        node = #if e.method(:burlap_node).arity > 0
          e.burlap_node(root_node)
        # else
        #   name, contents = e.burlap_node
        #   n = Nokogiri::XML::Node.new name, root_node.document
        #   n.content = contents
        #   n
        # end
        root_node.add_child node
      end

      root_node.to_xml
    end

  protected
    attr_writer :root, :data
  end

end
