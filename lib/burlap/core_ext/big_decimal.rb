#require "big_decimal"

class BigDecimal
  def to_burlap
    # <map><type>java.math.BigDecimal</type><string>value</string><string>0</string></map>
    Burlap::Hash[{:value => self}, "java.math.BigDecimal"].to_burlap
  end
end
