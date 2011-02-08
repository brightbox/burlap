class Array
  def to_burlap
    content = [Burlap::Node.new(:name => "length", :contents => size)]

    Burlap::Node.new(:name => "list", :contents => content)
  end
end