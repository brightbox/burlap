require "spec_helper"

unless 1.class == Integer
  describe Fixnum do
    describe "#to_burlap" do
      it "should encode a number to a <int>" do
        @result = 5.to_burlap
        @result.should == "<int>5</int>"
      end
    end
  end
end
