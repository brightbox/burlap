require "spec_helper"

describe NilClass do
  describe "#to_burlap" do
    before do
      @result = nil.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<null></null>"
    end
  end
end
