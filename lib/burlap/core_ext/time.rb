require "time"

class Time
  def burlap_node
    ["date", self.iso8601(3)]
  end
end