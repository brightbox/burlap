require "spec_helper"

describe Object do
  describe "#to_burlap" do
    it "should return a string" do
      Object.new.to_burlap.should be_a_kind_of(String)
    end
    it "should invoke Burlap::Hash with type of classname" do
      hash = mock(Burlap::Hash)
      Burlap::Hash.should_receive(:[]).with([], "Object").and_return(hash)
      hash.should_receive(:to_burlap).and_return("<my>xml</my>")

      Object.new.to_burlap.should == "<my>xml</my>"
    end
    describe "with instance variables" do

      class InstanceVariablesObject
        def initialize
          @one = 1
          @two = "something here"
          @three = :bingo
        end
      end

      before :all do
        @result = InstanceVariablesObject.new.to_burlap;
        @doc = Nokogiri::XML(@result)
      end

      it "should return a string" do
        @result.should be_a_kind_of(String)
      end
      it "should decompile into burlap" do
        xml_string = <<-EOF
          <map>
            <type>InstanceVariablesObject</type>

            <string>one</string>
            <int>1</int>

            <string>three</string>
            <string>bingo</string>

            <string>two</string>
            <string>something here</string>
          </map>
        EOF
        # Strip newlines & whitespace between tags - burlap is one string
        xml_string.gsub!(/(^|\n)\s*/m, "")
        @result.should == xml_string
      end
    end
  end
end
