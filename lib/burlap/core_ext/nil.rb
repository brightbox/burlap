class NilClass
  def to_burlap
    Burlap::Node.new(:name => "null", :value => "").to_burlap
  end
end