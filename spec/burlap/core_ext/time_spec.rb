require "spec_helper"

describe Time do
  describe "#to_burlap" do
    before do
      @result = Time.utc(2011, 9, 11, 10, 0).to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<date>20110911T100000.000Z</date>"
    end
    it "should not contain dashes" do
      @result.should_not =~ /-/
    end
    it "should not contain colons" do
      @result.should_not =~ /:/
    end
  end
end
