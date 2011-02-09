require "spec_helper"

describe Burlap::Node do

  describe "#to_burlap" do
    before :all do
      @result = Burlap::Node.new(:name => "method", :value => "updateUser").to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should put name in brackets" do
      @result.should == "<method>updateUser</method>"
    end
  end

end
