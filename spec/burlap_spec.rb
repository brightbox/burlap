require "spec_helper"

describe Burlap do

  it { Burlap.should respond_to(:resolver) }
  it { Burlap.should respond_to(:resolver=) }

  describe ".resolver" do
    it "should default to an instance of DefaultResolver" do
      Burlap.resolver.should be_a_kind_of(Burlap::DefaultResolver)
    end
  end

  describe ".parse" do
    it "should be specced"
  end

  describe ".dump" do
    it "should be specced"
  end

end
