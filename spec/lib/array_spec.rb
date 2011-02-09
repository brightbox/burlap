require "spec_helper"

describe Burlap::Array do
  describe "#to_burlap" do
    before do
      @result = Burlap::Array["some", :value].to_burlap
      p @result
      @doc = Nokogiri::XML(@result)
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be a list" do
      @doc.css("list").should have(1).element
    end
  end
end
