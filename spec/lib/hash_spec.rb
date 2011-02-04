require "spec/spec_helper"

describe Burlap::Hash do

  it "should inherit from Hash" do
    Burlap::Hash.ancestors.should include(Hash)
  end

  it "should behave like a Hash"

  describe "#__type__" do
    it "should default to Hash" do
      Burlap::Hash.new.__type__.should == "Hash"
    end
  end

  it { should respond_to(:__type__=) }

end
