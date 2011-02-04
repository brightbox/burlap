module Burlap
  module Emit
    def burlap_node
      [self.class.to_s.downcase, self.to_s]
    end
  end
end
