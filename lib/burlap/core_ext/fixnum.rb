class Fixnum
  def to_burlap
    Burlap::Node.new(:name => "int", :value => self).to_burlap
  end
end
