require "spec_helper"

describe Object do
  describe "#to_burlap" do
    before do
      pending "Should return a Burlap::Hash (map) of instance variables"
      @result = true.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct"
  end
end
