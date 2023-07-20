require "spec_helper"

RSpec.describe Burlap::Call do
  subject(:caller) { described_class.new(caller_args) }

  let(:caller_args) { { method: "updateUser" } }

  describe "#headers" do
    it "defaults to an array" do
      expect(caller.headers).to eq({})
    end
  end

  describe "#arguments" do
    it "defaults to a hash" do
      expect(caller.arguments).to eq([])
    end
  end

  describe "#method" do
    subject(:caller) { described_class.new({}) }

    it "is required" do
      expect { caller }.to raise_error(ArgumentError, "method is required")
    end
  end

  describe "#to_burlap" do
    subject(:burlap) { caller.to_burlap }

    before { Timecop.freeze(Time.local(2010, 9, 11, 10, 0, 0)) }

    after  { Timecop.return }

    context "single dimensional" do
      let(:caller_args) { { method: "updateUser", arguments: ["one", 2, 3.0, nil, true, Time.now] } }

      it "has a burlap:call root" do
        expect(burlap).to match(/\A<burlap:call>/)
        expect(burlap).to match(%r{</burlap:call>\z})
      end

      it "has a method element" do
        expect(burlap).to match(%r{<method>updateUser</method>})
      end

      it "has a string argument element" do
        expect(burlap).to match(%r{<string>one</string>})
      end

      it "has an int argument element" do
        expect(burlap).to match(%r{<int>2</int>})
      end

      it "has a double argument element" do
        expect(burlap).to match(%r{<double>3.0</double>})
      end

      it "has a null argument element" do
        expect(burlap).to match(%r{<null></null>})
      end

      it "has a boolean argument element" do
        expect(burlap).to match(%r{<boolean>1</boolean>})
      end

      it "has a date argument element" do
        expect(burlap).to match(%r{<date>#{Regexp.escape(Time.now.burlap_iso8601(3))}</date>})
      end
    end

    context "multi-dimensional" do
      let(:caller_args) { { method: "updateUser", arguments: ["one", contact] } }
      let(:contact) do
        Burlap::Hash[
          [
            ["number", 101],
            ["street", "auckland road"],
            %w[town elizabethtown],
            %w[country finland],
            ["foreign", true]
          ],
          "burlap.user"
        ]
      end

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "generates the right burlap" do
        # TODO: add headers
        xml_string = <<-XML
          <burlap:call>
            <method>updateUser</method>

            <string>one</string>

            <map>
              <type>burlap.user</type>

              <string>number</string>
              <int>101</int>

              <string>street</string>
              <string>auckland road</string>

              <string>town</string>
              <string>elizabethtown</string>

              <string>country</string>
              <string>finland</string>

              <string>foreign</string>
              <boolean>1</boolean>
            </map>

          </burlap:call>
        XML

        format_xml_as_burlap(xml_string)
        expect(burlap).to eq(xml_string)
      end
    end
  end
end
