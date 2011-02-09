require "time"

class Time
  def to_burlap
    Burlap::Node.new(:name => "date", :value => self.iso8601(3)).to_burlap
  end
end