module Burlap
  class DefaultResolver

    def mappings *names
      # Default's to a hash
      @mappings ||= {}
      # return early, return often. Or is that release?
      return @mappings if names.empty?

      raise ArgumentError, "block is required when name is given" unless block_given?

      # hack to get the passed block in a variable with less speed cost than &block in args
      block = Proc.new

      # Set said block for each name
      names.each do |name|
        @mappings[name] = block
      end

      @mappings
    end

    def convert_to_native obj
    end

  end

  # And set ourselves as the default
  self.resolver ||= DefaultResolver.new
end
