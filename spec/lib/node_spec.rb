require "spec_helper"

describe Burlap::Node do

  describe "#to_burlap" do
    describe "with a string" do
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
    describe "with nested XML" do
      before :all do
        @result = Burlap::Node.new(:name => "list", :value => "<length>1</length>").to_burlap
      end
      it "should return a string" do
        @result.should be_a_kind_of(String)
      end
      it "should not escape the value containing XML" do
        @result.should == "<list><length>1</length></list>"
      end
    end
  end

end
