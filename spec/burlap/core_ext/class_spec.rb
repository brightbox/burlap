require "spec_helper"

describe Class do
  describe "#to_burlap" do
    before do
      pending "Should raise an error as we can't decompile anonymous classes?"
      @result = Class.new.to_burlap
    end
    it "should raise an error"
    it "should be correct"
  end
end
