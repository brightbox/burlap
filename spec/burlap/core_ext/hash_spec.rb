require "spec_helper"

RSpec.describe Hash do
  describe "#to_burlap" do
    subject(:burlap) { { some: "hash" }.to_burlap }

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "is correct" do
      expect(burlap).to eq("<map><type></type><string>some</string><string>hash</string></map>")
    end
  end
end
