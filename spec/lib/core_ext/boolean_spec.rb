require "spec_helper"

describe TrueClass do
  describe "#to_burlap" do
    before do
      @result = true.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<boolean>1</boolean>"
    end
  end
end

describe FalseClass do
  describe "#to_burlap" do
    before do
      @result = false.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<boolean>0</boolean>"
    end
  end
end
