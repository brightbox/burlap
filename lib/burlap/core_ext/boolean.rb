class TrueClass
  def to_burlap
    Burlap::Node.new(:name => "boolean", :content => "1")
  end
end

class FalseClass
  def to_burlap
    Burlap::Node.new(:name => "boolean", :content => "0")
  end
end
