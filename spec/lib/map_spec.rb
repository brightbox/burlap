require "spec/spec_helper"

describe Burlap::Map do

  it { should respond_to(:type) }
  it { should respond_to(:type=) }
  describe "type" do
    it "should default to an empty string" do
      Burlap::Map.new.type.should == ""
    end
  end

  it { should respond_to(:contents) }
  it { should respond_to(:contents=) }

  describe "#burlap_node" do
    # <map><type>java.math.BigDecimal</type><string>value</string><string>0</string></map>
    it "should return a node"
    it "should have a nested type node"
    it "should have nested value nodes"
  end

end
