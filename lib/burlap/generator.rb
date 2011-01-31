module Burlap
  class Generator
    attr_reader :data

    def initialize data
      self.data = data
    end

    def dump
      raise RuntimeError, "not implemented"
    end

  protected
    attr_writer :data
  end
end