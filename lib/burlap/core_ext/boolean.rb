class TrueClass
  def to_burlap
    Burlap::Node.new(:name => "boolean", :value => "1").to_burlap
  end
end

class FalseClass
  def to_burlap
    Burlap::Node.new(:name => "boolean", :value => "0").to_burlap
  end
end
