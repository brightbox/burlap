module Burlap
  class Array < ::Array
    
    def to_burlap
      # <list><type>[string</type><length>1</length><string>Some</string></list>
      list_content = [
        Burlap::Node.new(:name => "type", :value => "").to_burlap,
        Burlap::Node.new(:name => "length", :value => self.length.to_s).to_burlap
      ]
      list_content += self.map do |element|
        element.to_burlap
      end
      list_content = list_content.join("")
      Burlap::Node.new(:name => "list", :value => list_content).to_burlap
    end

  end
end
