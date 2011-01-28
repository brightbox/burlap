module Brappa

  def self.parse_xml io_handle
    listener = Listener.new
    parser = Nokogiri::XML::SAX::Parser.new(listener)
    parser.parse(io_handle)
    listener.result
  end

end
