require "spec_helper"

describe Time do
  describe "#to_burlap" do
    before do
      @result = Time.local(2011, 9, 11, 10, 0).to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<date>#{Time.local(2011, 9, 11, 10, 0).iso8601(3)}</date>"
    end
  end
end
