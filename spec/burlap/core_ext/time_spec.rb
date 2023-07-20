require "spec_helper"

RSpec.describe Time do
  describe "#to_burlap" do
    subject(:burlap) { described_class.utc(2011, 9, 11, 10, 0).to_burlap }

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "is correct" do
      expect(burlap).to eq("<date>20110911T100000.000Z</date>")
    end

    it "does not contain dashes" do
      expect(burlap).not_to include("-")
    end

    it "does not contain colons" do
      expect(burlap).not_to include(":")
    end
  end
end
