module Burlap
  class Generator
    GeneratorError = Class.new(Burlap::Error)

    attr_reader :obj

    def initialize obj
      self.obj = obj
    end

    def to_burlap
      result = if obj.respond_to?(:to_burlap)
        obj.to_burlap
      else
        raise GeneratorError, "figure out how to dump #{obj.class}"
      end
      result#.to_xml
    end

  protected
    attr_writer :obj
  end

end
