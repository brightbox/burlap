require "spec_helper"

describe Symbol do
  describe "#to_burlap" do
    before do
      @result = :some_value.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<string>some_value</string>"
    end
  end
end
