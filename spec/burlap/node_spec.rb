require "spec_helper"

RSpec.describe Burlap::Node do
  describe "#to_burlap" do
    subject(:burlap) { described_class.new(name: "name", value: value).to_burlap }

    context "with a string" do
      let(:value) { "updateUser" }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "puts name in brackets" do
        expect(burlap).to eq("<name>updateUser</name>")
      end
    end

    context "with UTF8 characters" do
      let(:value) { "Håva" }

      it "uses decimal escaping for utf8 characters" do
        expect(burlap).to eq(%{<name>H&#229;va</name>})
      end
    end

    context "with nested XML" do
      let(:value) { "<length>1</length>" }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "does not escape the value containing XML" do
        expect(burlap).to eq("<name><length>1</length></name>")
      end
    end
  end
end
