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


  class Call
    attr_accessor :method, :arguments

    def initialize params={}
      @method = params[:method]
      @arguments = params[:arguments]
    end

    def to_burlap#_node
      @actual_doc = Nokogiri::XML::Document.new
      @doc = Nokogiri::XML::DocumentFragment.new @actual_doc

      root = @doc.create_element("burlap:call")
      @doc.add_child(root)

      root.add_child build_element(root, "method", @method)

      @arguments.each do |arg|
        root.add_child build_element(root, arg, arg)
      end

      @doc.to_s
    end

=begin
    def to_burlap
      @doc = Nokogiri::XML::Document.new

      @doc.add_child @doc.create_element("burlap:call")

      

    end
=end

    def build_element parent, name, obj
      if name == obj
        name = element_name(obj)
      end

      if obj.respond_to?(:to_xml_node)
        obj.to_xml_node @doc
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
