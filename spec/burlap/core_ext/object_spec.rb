require "spec_helper"

RSpec.describe Object do
  describe "#to_burlap" do
    subject(:burlap) { described_class.new.to_burlap }

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "invokes Burlap::Hash with type of classname" do
      hash = instance_double(Burlap::Hash)
      expect(Burlap::Hash).to receive(:[]).with([], "Object").and_return(hash)
      expect(hash).to receive(:to_burlap).and_return("<my>xml</my>")

      expect(burlap).to eq("<my>xml</my>")
    end

    context "with instance variables" do
      subject(:burlap) { InstanceVariablesObject.new.to_burlap }

      let(:klass) do
        Class.new do
          def initialize
            @one = 1
            @two = "something here"
            @three = :bingo
          end
        end
      end

      before do
        stub_const("InstanceVariablesObject", klass)
        @doc = Nokogiri::XML(@result)
      end

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "decompiles into burlap" do
        xml_string = <<-XML
          <map>
            <type>InstanceVariablesObject</type>

            <string>one</string>
            <int>1</int>

            <string>three</string>
            <string>bingo</string>

            <string>two</string>
            <string>something here</string>
          </map>
        XML

        format_xml_as_burlap(xml_string)
        expect(burlap).to eq(xml_string)
      end
    end
  end
end
