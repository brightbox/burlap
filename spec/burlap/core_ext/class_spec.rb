require "spec_helper"

describe Class do
  describe "#to_burlap" do
    # we can't dump anonymous classes
    it "should raise an error" do
      pending
      expect { Class.new.to_burlap }.to raise_error
    end
  end
end
