require "spec_helper"

describe Array do
  describe "#to_burlap" do
    before do
      pending "Needs to return a <list>, calling #to_burlap on contents"
      @result = ["some", :value].to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct"
  end
end
