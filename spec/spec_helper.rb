require "rubygems"
require "bundler/setup"
require "rspec"
require "active_support"
require "active_support/core_ext/hash/except"
require "timecop"

require "burlap"

# Strip newlines & whitespace between tags - burlap is one string
def format_xml_as_burlap(xml_string)
  xml_string.gsub!(/(^|\n)\s*/m, "")
end
