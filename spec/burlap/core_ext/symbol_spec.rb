require "spec_helper"

RSpec.describe Symbol do
  describe "#to_burlap" do
    subject(:burlap) { :some_value.to_burlap }

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "is correct" do
      expect(burlap).to eq("<string>some_value</string>")
    end
  end
end
