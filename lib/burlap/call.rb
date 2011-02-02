module Burlap
  class Call
    attr_accessor :headers, :method, :arguments

    def initialize params={}
      params.each do |key, value|
        method = :"#{key}="
        send(method, value) if respond_to?(method)
      end
    end

    

  end
end