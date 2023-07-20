require "spec_helper"

describe Class do
  describe "#to_burlap" do
    subject(:burlap) { described_class.new.to_burlap }

    # FIXME: The comment "we can't dump anonymous classes" implies this
    #        shouldn't work or it shouldn't work as it currently does
    #        but the intent has been lost. This test confirms the
    #        current behaviour as implemented.
    #
    it "doesn't raise an error" do
      expect { burlap }.not_to raise_error
    end

    it "returns a string" do
      expect(burlap).to be_a_kind_of(String)
    end

    it "is returning a string..." do
      expect(burlap).to eq("<map><type>Class</type></map>")
    end
  end
end
