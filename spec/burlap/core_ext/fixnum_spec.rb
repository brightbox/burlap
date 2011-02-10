require "spec_helper"

describe Fixnum do
  describe "#to_burlap" do
    before do
      @result = 5.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<int>5</int>"
    end
  end
end
