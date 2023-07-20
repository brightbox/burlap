require "spec_helper"

RSpec.describe Burlap::Array do
  describe "#to_burlap" do
    subject(:burlap) { array.to_burlap }

    let(:array) { described_class["some", mock_obj] }
    let(:mock_obj) { instance_double(Object, to_burlap: "<mock>my stuff here</mock>") }

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "is correct" do
      xml_string = <<-XML
      <list>
        <type></type>
        <length>2</length>
        <string>some</string>
        <mock>my stuff here</mock>
      </list>
      XML

      format_xml_as_burlap(xml_string)
      expect(burlap).to eq(xml_string)
    end
  end
end
