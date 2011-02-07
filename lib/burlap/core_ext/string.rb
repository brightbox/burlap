class String
  def to_burlap
    Burlap::Node.new(:name => "string", :content => self)
  end
end
