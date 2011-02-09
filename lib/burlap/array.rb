module Burlap
  class Array < ::Array

    def to_burlap
      list_content = [Burlap::Node.new(:name => "length", :value => self.length.to_s).to_burlap]
      list_content = list_content.join("")
      Burlap::Node.new(:name => "list", :value => list_content).to_burlap
    end

  end
end