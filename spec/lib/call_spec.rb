require "spec/spec_helper"

describe Burlap::Call do

  before do
    @valid_params = {}
  end

  describe "#headers" do
    it "should default to an array" do
      Burlap::Call.new(@valid_params).headers.should == []
    end
  end

  describe "#arguments" do
    it "should default to an array" do
      Burlap::Call.new(@valid_params).arguments.should == []
    end
  end

  describe "#method" do
    it "should be required" do
      Burlap::Call.new(@valid_params.except(:method)).should raise_error(ArgumentError, "method is required")
    end
  end

end
