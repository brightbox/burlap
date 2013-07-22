class String
  def to_burlap
    Burlap::Node.new(:name => "string", :value => ERB::Util.html_escape(self)).to_burlap
  end
end
