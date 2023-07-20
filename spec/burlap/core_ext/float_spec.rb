require "spec_helper"

RSpec.describe Float do
  describe "#to_burlap" do
    subject(:burlap) { 5.0.to_burlap }

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "is correct" do
      expect(burlap).to eq("<double>5.0</double>")
    end
  end
end
