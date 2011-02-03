require "rubygems"
require "nokogiri"

module Burlap
  module MapNode
    def to_xml_node doc
      @node = Nokogiri::XML::Node.new "map", doc

      @node.add_child doc.create_element("type", burlap_type)

      attributes.each do |getter|
        obj = send(getter)
        @node.add_child doc.create_element(element_name(obj), obj)
      end

      @node
    end

    def element_name obj
      case obj
      when Fixnum
        "int"
      else
        if obj.respond_to? :xml_node_name
          obj.xml_node_name
        else
          obj.class.to_s.downcase
        end
      end
    end
  end

  class Contact
    include MapNode
    attr_accessor :city, :county, :country, :postcode

    def initialize params={}
      params.each do |key, value|
        method = :"#{key}="
        send method, value if respond_to? method
      end
    end

    def xml_node_name
      "map"
    end

    def burlap_type
      "com.sapienter.jbilling.server.user.UserContactWS"
    end

    def attributes
      [:city, :county, :country, :postcode]
    end
  end
  
  class User
    include MapNode
    attr_accessor :name, :age, :creditCard

    def initialize params={}
      params.each do |key, value|
        method = :"#{key}="
        send method, value if respond_to? method
      end
    end

    def xml_node_name
      "map"
    end

    def burlap_type
      "com.sapienter.jbilling.server.user.UserWS"
    end

    def attributes
      [:name]
    end
  end

  class EmitNode
    attr_accessor :parent, :object

    def self.new *args
      en = super
      en.to_node
    end

    def initialize params={}
      self.parent = params[:parent]
      self.object = params[:object]
    end

    def to_node
      data = object.burlap_data
    end

    def document
      parent.document
    end
  end

  class Call
    attr_accessor :method, :arguments

    def initialize params={}
      @method = params[:method]
      @arguments = params[:arguments]
    end

    def burlap_data
      [
        {"method" => @method},
        @arguments
      ]
    end

    def to_burlap#_node
      @doc = Nokogiri::XML::Document.new
      root = Nokogiri::XML::Node.new "burlap:call", @doc

      @doc.add_child root

      root.add_child EmitNode.new(:parent => root, :object => self)

      root.add_child build_element(root, "method", @method)

      @arguments.each do |arg|
        root.add_child build_element(root, arg, arg)
      end

      root.to_xml
    end

=begin
    def to_burlap
      @doc = Nokogiri::XML::Document.new

      @doc.add_child @doc.create_element("burlap:call")

      EmitNode.new(:parent => @doc, :)

    end
=end

    def build_element parent, name, obj
      if name == obj
        name = element_name(obj)
      end

      if obj.respond_to?(:to_xml_node)
        obj.to_xml_node parent.document
      else
        @doc.create_element(name, obj.to_s)
      end
    end

    def element_name obj
      case obj
      when Fixnum
        "int"
      else
        if obj.respond_to? :xml_node_name
          obj.xml_node_name
        else
          obj.class.to_s.downcase
        end
      end
    end

  end
end

data = {
  :method => "updateUser",
  :arguments => [
    "fooey",
    1,
    2,
    Burlap::User.new(
      :name => "Caius",
      :contact => Burlap::Contact.new(
        :city => "Leeds",
        :country => "UK"
      )
    )
  ]
}

call = Burlap::Call.new(data)

print DATA.read
puts
print call.to_burlap

__END__
<burlap:call>
  <method>updateUser</method>
  <string>fooey</string>
  <int>1</int>
</burlap:call>
