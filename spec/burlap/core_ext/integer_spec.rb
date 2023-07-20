require "spec_helper"

describe Integer do
  describe "#to_burlap" do
    # https://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html
    # maximum value an int can have, 2**31-1.
    # minimum value an int can have, -2**31.
    context "when within 32bit signed limits" do
      it "encodes the Integer as 'int'" do
        expect(5.to_burlap).to eq("<int>5</int>")
        expect(-5.to_burlap).to eq("<int>-5</int>")

        expect(2_147_483_647.to_burlap).to eq("<int>2147483647</int>")
        expect(-2_147_483_648.to_burlap).to eq("<int>-2147483648</int>")
      end
    end

    context "when outside 32bit signed limits" do
      it "encodes the Integer as 'java.math.BigDecimal'" do
        expect(2_147_483_648.to_burlap).to eq("<map><type>java.math.BigDecimal</type><string>value</string><string>2147483648</string></map>")
        expect(-2_147_483_649.to_burlap).to eq("<map><type>java.math.BigDecimal</type><string>value</string><string>-2147483649</string></map>")

        expect(999_999_999_999_999_999.to_burlap).to eq("<map><type>java.math.BigDecimal</type><string>value</string><string>999999999999999999</string></map>")
        expect(-999_999_999_999_999_999.to_burlap).to eq("<map><type>java.math.BigDecimal</type><string>value</string><string>-999999999999999999</string></map>")
      end
    end
  end
end
