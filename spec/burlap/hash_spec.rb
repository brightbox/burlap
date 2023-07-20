require "spec_helper"

RSpec.describe Burlap::Hash do
  it "inherits from ordered hash" do
    expect(described_class.ancestors).to include(ActiveSupport::OrderedHash)
  end

  it { is_expected.to respond_to(:__type__) }
  it { is_expected.to respond_to(:__type__=) }

  describe "#__type__" do
    it "defaults to an empty string" do
      expect(described_class.new.__type__).to eq("")
    end
  end

  describe "#[]" do
    subject(:burlap_hash) { described_class[input] }

    context "when input is a Hash" do
      let(:input) { {} }

      it "is compatible with Hash#[]" do
        expect(burlap_hash.keys).to eq([])
        expect(burlap_hash.values).to eq([])
      end

      it "is empty string" do
        expect(burlap_hash.__type__).to eq("")
      end
    end

    context "when one argument is given" do
      let(:input) { { "one" => "two", "three" => "four" } }

      it "is compatible with Hash#[]" do
        expect(burlap_hash.keys).to eq(%w[one three])
        expect(burlap_hash.values).to eq(%w[two four])
      end

      it "is empty string" do
        expect(burlap_hash.__type__).to eq("")
      end
    end

    context "when a __type__ is passed" do
      let(:input) { { some: "options", __type__: "is ignored" } }

      it "is compatible with Hash#[]" do
        expect(burlap_hash.keys).to eq(%i[some __type__])
        expect(burlap_hash.values).to eq(["options", "is ignored"])
      end

      it "is empty string" do
        expect(burlap_hash.__type__).to eq("")
      end
    end

    context "when a second argument sets type directly" do
      subject(:burlap_hash) { described_class[input, "com.java.hashmap"] }

      context "without a passed __type__" do
        let(:input) { { some: "options" } }

        it "is compatible with Hash#[]" do
          expect(burlap_hash.keys).to eq([:some])
          expect(burlap_hash.values).to eq(["options"])
        end

        it "sets __type__ directly" do
          expect(burlap_hash.__type__).to eq("com.java.hashmap")
        end
      end

      context "with a passed __type__" do
        let(:input) { { some: "options", __type__: "is ignored" } }

        it "is compatible with Hash#[]" do
          expect(burlap_hash.keys).to eq(%i[some __type__])
          expect(burlap_hash.values).to eq(["options", "is ignored"])
        end

        it "sets __type__ directly" do
          expect(burlap_hash.__type__).to eq("com.java.hashmap")
        end
      end
    end
  end

  describe "#inspect" do
    subject(:burlap_hash) { described_class[[%w[one two], [:three, 4]], "Fred"] }

    it "does not contain OrderedHash" do
      expect(burlap_hash.inspect).not_to include("OrderedHash")
    end

    it "starts with Burlap::Hash" do
      expect(burlap_hash.inspect).to match(/#<Burlap::Hash/)
    end

    it "contains the hash, inspected" do
      expect(burlap_hash.inspect).to include(%({"one"=>"two", :three=>4}))
    end

    it "contains the type, inspected" do
      expect(burlap_hash.inspect).to include(%{__type__="Fred"})
    end
  end

  describe "#to_burlap" do
    subject(:burlap) { burlap_hash.to_burlap }

    let(:burlap_hash) { described_class[{ value: "something" }, "org.ruby-lang.string"] }

    context "wrapping a string" do
      # <map>
      #   <type>org.ruby-lang.string</type>
      #   <string>value</string>
      #   <string>something</string>
      # </map>

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "has a map root" do
        expect(burlap).to match(/^<map>/)
        expect(burlap).to match(%r{</map>$})
      end

      it "has a nested type node" do
        expect(burlap).to match(%r{<type>org.ruby-lang.string</type>})
      end

      it "has nested value nodes" do
        expect(burlap).to match(%r{<string>value</string>})
        expect(burlap).to match(%r{<string>something</string>})
      end
    end

    context "wrapping multiple keys" do
      let(:burlap_hash) { described_class[[["name", "caius durling"], ["age", 101]], "burlap.user"] }

      before do
        @doc = Nokogiri::XML(burlap)
      end

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "is correct" do
        xml_string = <<-XML
        <map>
          <type>burlap.user</type>
          <string>name</string>
          <string>caius durling</string>
          <string>age</string>
          <int>101</int>
        </map>
        XML

        format_xml_as_burlap(xml_string)
        expect(burlap).to eq(xml_string)
      end

      it "has a type element" do
        expect(burlap).to match(%r{<type>burlap.user</type>})
      end

      it "has a name keypair" do
        expect(burlap).to match(%r{<string>name</string><string>caius durling</string>})
      end

      it "has an age keypair" do
        expect(burlap).to match(%r{<string>age</string><int>101</int>})
      end
    end

    context "wrapping nested keys" do
      let(:burlap_hash) { described_class[[["people", { "name" => "caius durling", "age" => 101 }]], "burlap-peoples"] }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "is generated properly, including nested elements" do
        xml_string = <<-XML
          <map>
            <type>burlap-peoples</type>

            <string>people</string>
            <map>
              <type></type>

              <string>name</string>
              <string>caius durling</string>

              <string>age</string>
              <int>101</int>
            </map>

          </map>
        XML
        xml_string.gsub!(/(^|\n)\s*/m, "")
        expect(burlap).to eq(xml_string)
      end
    end

    context "wrapping empty arrays" do
      let(:burlap_hash) { described_class[{ numbers: [] }] }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "is generated properly" do
        xml_string = <<-XML
          <map>
            <type></type>

            <string>numbers</string>
            <list>
              <type></type>
              <length>0</length>
            </list>
          </map>
        XML
        xml_string.gsub!(/(^|\n)\s*/m, "")
        expect(burlap).to eq(xml_string)
      end
    end
  end
end
