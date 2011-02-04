module Burlap
  class Hash < ::Hash
    attr_writer :__type__

    def __type__
      @__type__ ||= "Hash"
    end

  end
end
