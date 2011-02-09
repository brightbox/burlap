class Symbol
  def to_burlap
    # Return the same as if we were a string
    self.to_s.to_burlap
  end
end