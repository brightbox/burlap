class Object
  def to_burlap
    dict = {}

    vars = instance_variables.map do |var|
      key = var[/^@(.*)$/, 1]
      value = instance_variable_get(var)
      [key, value]
    end.sort_by {|e| e.first }

    p vars

    Burlap::Hash[vars, self.class.to_s].to_burlap
  end
end
