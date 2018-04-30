if 1.class == Integer
  class Integer
    def to_burlap
      if between?(-2**31, 2**31-1)
        Burlap::Node.new(:name => "int", :value => self.to_i).to_burlap
      else
        # <map><type>java.math.BigDecimal</type><string>value</string><string>0</string></map>
        Burlap::Hash[{:value => self.to_i.to_s}, "java.math.BigDecimal"].to_burlap
      end
    end
  end
end
