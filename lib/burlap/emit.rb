module Burlap
  module Emit
    def burlap_node
      [self.class.to_s.downcase, self]
    end
  end
end
