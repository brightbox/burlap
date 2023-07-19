require "spec_helper"

describe Hash do
  describe "#to_burlap" do
    before do
      pending "should return a <map> (Burlap::Hash)"
      @result = {:some => :bar}.to_burlap
      @result.should be_a_kind_of Burlap::Hash
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct"
  end
end
