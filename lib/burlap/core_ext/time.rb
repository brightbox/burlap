require "time"

class Time
  def to_burlap
    Burlap::Node.new(:name => "date", :content => self.iso8601(3))
  end
end