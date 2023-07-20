require "spec_helper"

RSpec.describe FalseClass do
  describe "#to_burlap" do
    before do
      @result = false.to_burlap
    end

    it "returns a string" do
      expect(@result).to be_a_kind_of(String)
    end

    it "is correct" do
      expect(@result).to eq("<boolean>0</boolean>")
    end
  end
end
