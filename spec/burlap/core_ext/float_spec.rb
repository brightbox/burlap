require "spec_helper"

describe Float do
  describe "#to_burlap" do
    before do
      @result = 5.0.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<double>5.0</double>"
    end
  end
end
