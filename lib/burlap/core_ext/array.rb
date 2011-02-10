class Array
  def to_burlap
    # We use the splat here so it creates an array with our elements,
    # rather than an array containing an array of our elements
    Burlap::Array[*to_a].to_burlap
  end
end
