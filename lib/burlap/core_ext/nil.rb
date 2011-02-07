class NilClass
  def to_burlap
    Burlap::Node.new(:name => "null", :content => "")
  end
end