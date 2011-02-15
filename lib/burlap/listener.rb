require "nokogiri"

module Burlap
  class Listener < Nokogiri::XML::SAX::Document
    attr_accessor :result

    def initialize
      @result = nil
      @open = []
    end

    def start_element name, attrs=[]
      @open.push BaseTag.new(:name => name)
    end

    def characters contents
      @open.last.value += contents if @open.last
    end

    def end_element name
      last = @open.pop
      if @open.empty?
        @result = last.to_ruby
      else
        @open.last.children.push last
      end
    end

  private
    attr_writer :data

  end

end
