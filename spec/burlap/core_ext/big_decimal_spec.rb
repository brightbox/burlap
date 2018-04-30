require "spec_helper"

unless 1.class == Integer
  require "bigdecimal"
  require "burlap/core_ext/big_decimal"
  describe BigDecimal do
    describe "#to_burlap" do
      it "should encode a BigDecimal as a java.math.BigDecimal" do
        @result = BigDecimal.new(999999999999999999).to_burlap
        @result.should == "<map><type>java.math.BigDecimal</type><string>value</string><string>999999999999999999</string></map>"
      end
    end
  end
end
