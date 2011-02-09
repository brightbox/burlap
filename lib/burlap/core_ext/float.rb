class Float
  def to_burlap
    Burlap::Node.new(:name => "double", :value => self).to_burlap
  end
end
