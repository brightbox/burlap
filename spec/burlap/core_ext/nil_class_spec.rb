require "spec_helper"

RSpec.describe NilClass do
  describe "#to_burlap" do
    subject(:burlap) { nil.to_burlap }

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "is correct" do
      expect(burlap).to eq("<null></null>")
    end
  end
end
