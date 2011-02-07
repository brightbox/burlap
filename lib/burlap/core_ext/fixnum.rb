class Fixnum
  def to_burlap
    Burlap::Node.new(:name => "int", :content => self)
  end
end
