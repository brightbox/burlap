require "spec_helper"

describe Array do
  describe "#to_burlap" do
    it "should return a string" do
      [].to_burlap.should be_a_kind_of(String)
    end
    it "should create a Burlap::Array instance from itself and delegate #to_burlap to it" do
      @array = ["foo", :bar]

      mock_burlap_array = mock(Burlap::Array)
      Burlap::Array.should_receive(:[]).with(*@array).and_return(mock_burlap_array)
      mock_burlap_array.should_receive(:to_burlap).and_return("<burlap>array</burlap>")

      @array.to_burlap.should == "<burlap>array</burlap>"
    end
  end
end
