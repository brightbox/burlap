
module Burlap
  class Generator
    attr_reader :data

    def initialize data
      raise ArgumentError, "data must be a hash" unless data.is_a?(Hash)
      self.data = data
    end

    def dump
      
    end

  protected
    attr_writer :data
  end

  

end



data = {"method" => "fred", "args" => }

Burlap::Generator.dump(data)


__END__
<burlap:call>
  <method>fred</method>
  <string>blogs</string>
  <int>1</int>
</burlap:call>