require "spec/spec_helper"

describe Burlap::Generator do
  before do
    @valid_params = {"root" => ["some", "data"]}
    @generator = Burlap::Generator.new(@valid_params)
  end

  describe "#new" do
    it "should require a hash" do
      lambda {
        Burlap::Generator.new(nil)
      }.should raise_error(ArgumentError, "data is not a Hash")
    end
    it "should require only one root element" do
      lambda {
        Burlap::Generator.new(@valid_params.merge("second_root" => ["more", "data"]))
      }.should raise_error(ArgumentError, "data can only contain one root element")
    end
  end

  it { @generator.should respond_to(:to_xml) }
  describe "#to_xml" do
    before do
      @dump = @generator.to_xml
      @doc = Nokogiri::XML(@dump)
    end
    it "should return a string" do
      @dump.should be_a_kind_of(String)
    end
    it "should have a root element" do
      root = @doc.css("root")
      root.should have(1).element
      root.first.should be_a_kind_of(Nokogiri::XML::Node)
      root.first.name.should == "root"
    end
    it "should have a nested string elements" do
      strings = @doc.css("string")
      strings.should have(2).elements
      strings.each do |str|
        str.should be_a_kind_of(Nokogiri::XML::Node)
        str.name.should == "string"
        %w(some data).should include(str.content)
      end
    end
  end

end
