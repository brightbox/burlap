require "spec_helper"

describe String do
  describe "#to_burlap" do
    before do
      @result = "some string".to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<string>some string</string>"
    end
  end
end
