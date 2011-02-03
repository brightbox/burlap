require "spec/spec_helper"

describe Burlap::Call do

  before do
    @valid_params = {:method => "updateUser"}
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
      lambda { Burlap::Call.new(@valid_params.except(:method)) }.should raise_error(ArgumentError, "method is required")
    end
  end

  describe "#to_burlap" do
    before(:all) do
      @call = Burlap::Call.new(:method => "updateUser", :arguments => ["one", 2, 3.0])
      @response = @call.to_burlap
    end
    it "should have a burlap:call root" do
      @response.should =~ /\A<burlap:call>/
      @reponse.should =~ %r{</burlap:call>\z}
    end
    it "should have a method element"
    it "should have three argument elements"
    it "should have a string argument element"
    it "should have an int argument element"
    it "should have a double argument element"
  end

end
