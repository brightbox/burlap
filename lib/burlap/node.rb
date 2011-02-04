module Burlap
  class Node
    # name is the element name to go in the <>
    # and content is a string to go inside <></>
    attr_accessor :name, :content

    def initialize params={}
      self.name = params[:name]
      self.content = params[:content]
    end
    
    def burlap_node
      [name, content]
    end
  end
end