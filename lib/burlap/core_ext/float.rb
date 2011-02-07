class Float
  def to_burlap
    Burlap::Node.new(:name => "double", :content => self)
  end
end
