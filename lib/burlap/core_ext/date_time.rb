class DateTime
  def to_burlap
    Burlap::Node.new(:name => "date", :value => self.burlap_iso8601(3)).to_burlap
  end
end
