require "time"
require "ostruct"

module Burlap
  class DefaultResolver
    def mappings(*names, &block)
      # Default's to a hash
      @mappings ||= {}
      # return early, return often. Or is that release?
      return @mappings if names.empty?

      # Set said block for each name
      names.each do |name|
        @mappings[name] = proc(&block)
      end

      @mappings
    end

    # obj is expected to respond to #name, #value and #children
    # (eg, an instance of BaseTag)
    def convert_to_native obj
      mapping = mappings[obj.name] || raise(Error, "couldn't handle tag #{obj.name.inspect}")
      mapping.call(obj)
    end
  end

  # And set ourselves as the default
  self.resolver ||= DefaultResolver.new
end

Burlap.resolver.mappings "burlap:reply" do |tag|
  tag.children.first.to_ruby if tag.children.first
end

Burlap.resolver.mappings "map" do |tag|
  # Pop the first element off
  t = tag.children.shift.to_ruby

  # then parse the rest of the children as key/values
  values = tag.parse_matched_pairs

  Burlap::Hash[values, t]
end

Burlap.resolver.mappings "fault" do |tag|
  # Parse the children as key/values
  values = tag.parse_matched_pairs

  # and then turn it into an open struct
  if RUBY_VERSION > '1.9'
    Burlap::Fault.new(Hash[values])
  else
    Burlap::Fault.new(values)
  end
end

Burlap.resolver.mappings "type", "string" do |tag|
  tag.value.to_s
end

Burlap.resolver.mappings "int", "length" do |tag|
  tag.value.to_i
end

Burlap.resolver.mappings "double" do |tag|
  tag.value.to_f
end

Burlap.resolver.mappings "null" do |tag|
  nil
end

Burlap.resolver.mappings "date" do |tag|
  ::Time.parse(tag.value) if tag.value
end

Burlap.resolver.mappings "list" do |tag|
  # We don't actually care about the type or length of the
  # array in ruby, but we shift it out the way so we can ignore it.
  t = tag.children.shift.to_ruby
  length = tag.children.shift.to_ruby

  # Parse the rest of the children as key/values
  values = tag.children.map &:to_ruby

  Burlap::Array[*values]
end

Burlap.resolver.mappings "ref" do |tag|
  tag.value
end

Burlap.resolver.mappings "boolean" do |tag|
  tag.value.to_i == 1
end

Burlap.resolver.mappings "base64" do |tag|
  Base64.decode64(tag.value.to_s)
end
