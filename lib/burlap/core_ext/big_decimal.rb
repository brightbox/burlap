#require "big_decimal"

class BigDecimal
  def burlap_node
    # <map><type>java.math.BigDecimal</type><string>value</string><string>0</string></map>
    Burlap::Map.new(:type => "java.math.BigDecimal", :contents => self)
  end
end
