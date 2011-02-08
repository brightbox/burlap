require "spec/spec_helper"

describe Burlap::Generator do

  it { @generator.should respond_to(:to_burlap) }
  describe "#to_burlap" do
    before :all do
      @valid_params = {"root" => ["some", "data"]}
      @generator = Burlap::Generator.new(@valid_params)
      @dump = @generator.to_burlap
      puts @dump.inspect
      @doc = Nokogiri::XML(@dump)
    end
    it "should return a string" do
      @dump.should be_a_kind_of(String)
    end
    it "should have a root element" do
      root = @doc.css("map")
      root.should have(1).element
      root.first.should be_a_kind_of(Nokogiri::XML::Node)
      root.first.name.should == "map"
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
