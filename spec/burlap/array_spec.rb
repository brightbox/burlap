require "spec_helper"

describe Burlap::Array do
  describe "#to_burlap" do
    before do
      @mock_obj = mock(Object, :to_burlap => "<mock>my stuff here</mock>")
      @array = Burlap::Array["some", @mock_obj]
      @result = @array.to_burlap
      @doc = Nokogiri::XML(@result)
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be a list" do
      @doc.css("list").should have(1).element
    end
    it "should have a type attribute" do
      type, = element_exists_with :selector => "type", :count => 1
      type.name.should == "type"
      type.content.should == ""
    end
    it "should have a length attribute" do
      value, = element_exists_with :selector => "length", :count => 1
      value.name.should == "length"
      value.content.should == @array.size.to_s
    end
    it "should have a string attribute" do
      str, = element_exists_with :selector => "string", :count => 1
      str.name.should == "string"
      str.content.should == "some"
    end
    it "should have a mock attribute" do
      obj, = element_exists_with :selector => "mock", :count => 1
      obj.name.should == "mock"
      obj.content.should == "my stuff here"
    end

  end
end
