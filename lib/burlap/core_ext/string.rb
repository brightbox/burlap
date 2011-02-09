class String
  def to_burlap
    Burlap::Node.new(:name => "string", :value => self).to_burlap
  end
end
