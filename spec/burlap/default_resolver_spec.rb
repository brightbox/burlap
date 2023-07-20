require "spec_helper"

RSpec.describe Burlap::DefaultResolver do
  subject(:resolver) { described_class.new }

  describe "#mappings" do
    it "defaults to a hash" do
      expect(resolver.mappings).to eq({})
    end

    context "when passed a name and block" do
      it "stores a single mapping" do
        expect(resolver.mappings["first"]).to be_nil

        resolver.mappings("first") do
          "result of call"
        end

        result = resolver.mappings["first"]

        expect(result).not_to be_nil
        expect(result).to be_a_kind_of(Proc)
        expect(result.call).to eq("result of call")
      end
    end

    context "when passed more than one name at once" do
      it "stores the same block against multiple mappings" do
        resolver.mappings("first", "second") do
          "result of call"
        end

        result = resolver.mappings["first"]
        expect(result).not_to be_nil
        expect(result).to respond_to(:call)
        expect(result.call).to eq("result of call")

        result = resolver.mappings["second"]
        expect(result).not_to be_nil
        expect(result).to respond_to(:call)
        expect(result.call).to eq("result of call")
      end
    end
  end

  describe ".convert_to_native" do
    subject(:resolver) { Burlap.resolver }

    context "when input is 'int'" do
      let(:burlap_tag) { Burlap::BaseTag.new(name: "int", value: "15") }

      it "is parsed into ruby" do
        expect(resolver.convert_to_native(burlap_tag)).to eq(15)
      end
    end

    context "when input is 'double" do
      let(:burlap_tag) { Burlap::BaseTag.new(name: "double", value: "1.5") }

      it "is parsed into ruby" do
        expect(resolver.convert_to_native(burlap_tag)).to eq(1.5)
      end
    end

    context "when input is 'string" do
      let(:burlap_tag) { Burlap::BaseTag.new(name: "string", value: "some string value") }

      it "is parsed into ruby" do
        expect(resolver.convert_to_native(burlap_tag)).to eq("some string value")
      end
    end

    context "when input is 'null" do
      let(:burlap_tag) { Burlap::BaseTag.new(name: "null", value: "") }

      it "is parsed into ruby" do
        expect(resolver.convert_to_native(burlap_tag)).to eq(nil)
      end
    end

    context "when input is 'with 'boolean'" do
      let(:burlap_tag) { Burlap::BaseTag.new(name: "boolean", value: value) }

      context "with true (1)" do
        let(:value) { "1" }

        it "parses true" do
          expect(resolver.convert_to_native(burlap_tag)).to be(true)
        end
      end

      context "with false (0)" do
        let(:value) { "0" }

        it "parses false" do
          expect(resolver.convert_to_native(burlap_tag)).to be(false)
        end
      end
    end

    describe ".parse" do
      subject(:parsed_burlap) { Burlap.parse(burlap) }

      context "with empty array" do
        let(:burlap) { "<list><type>[java.lang.Integer</type><length>0</length></list>" }

        it "parses an empty array" do
          expect(parsed_burlap).to eq([])
        end
      end

      context "when single element" do
        let(:burlap) { "<list><type>[string</type><length>1</length><string>1</string></list>" }

        it "parses an array" do
          expect(parsed_burlap).to eq(["1"])
        end
      end

      context "when multiple elements" do
        let(:burlap) { %{<list><type></type><length>3</length><int>0</int><double>1.3</double><string>foobar</string></list>} }

        it "parses an array" do
          expect(parsed_burlap).to eq([0, 1.3, "foobar"])
        end
      end

      context "with 'base64' encoded" do
        let(:burlap) { "<base64>#{encoded}</base64>" }
        let(:decoded) { "some string of some text" }
        let(:encoded) { Base64.encode64(decoded) }

        it "parses and return as a string" do
          expect(parsed_burlap).to be_a_kind_of(String)
          expect(parsed_burlap).to eq(decoded)
        end
      end
    end
  end
end
