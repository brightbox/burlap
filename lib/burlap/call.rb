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
      @headers ||= {}
    end

    def arguments
      @arguments ||= []
    end

    def to_burlap

      # todo: handle headers
      burlap_data = [Burlap::Node.new(:name => "method", :content => method)]
      arguments.each do |arg|
        b = arg.to_burlap
        burlap_data << b
      end

      Burlap::Node.new(:name => "burlap:call", :contents => burlap_data).to_burlap
    end

  protected

    def validate_attributes
      raise(ArgumentError, "method is required") unless self.method
    end

  end
end
