module Burlap
  class Call
    attr_accessor :headers, :method, :arguments

    def initialize params={}
      params.each do |key, value|
        method = :"#{key}="
        send(method, value) if respond_to?(method)
      end

      validate_attributes
    end

    def headers
      @headers ||= []
    end

    def arguments
      @arguments ||= []
    end

    def to_burlap
      
    end

  protected

    def validate_attributes
      raise(ArgumentError, "method is required") unless self.method
    end

  end
end