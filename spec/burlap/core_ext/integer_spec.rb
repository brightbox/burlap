require "spec_helper"

if 1.class == Integer
  describe Integer do
    describe "#to_burlap" do
      # https://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html
      # maximum value an int can have, 2**31-1.
      # minimum value an int can have, -2**31.
      it "should encode the Integer as an <int> when within 32bit signed limits" do
        5.to_burlap.should == "<int>5</int>"
        -5.to_burlap.should == "<int>-5</int>"
        2147483647.to_burlap.should == "<int>2147483647</int>"
        -2147483648.to_burlap.should == "<int>-2147483648</int>"
      end
      it "should encode the Integer as as java.math.BigDecimal when outside 32bit signed limits" do
        2147483648.to_burlap.should == "<map><type>java.math.BigDecimal</type><string>value</string><string>2147483648</string></map>"
        -2147483649.to_burlap.should == "<map><type>java.math.BigDecimal</type><string>value</string><string>-2147483649</string></map>"
        999999999999999999.to_burlap.should == "<map><type>java.math.BigDecimal</type><string>value</string><string>999999999999999999</string></map>"
        -999999999999999999.to_burlap.should == "<map><type>java.math.BigDecimal</type><string>value</string><string>-999999999999999999</string></map>"
      end

    end
  end
end
