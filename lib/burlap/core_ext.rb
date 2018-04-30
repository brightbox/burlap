require "burlap/core_ext/array"
require "burlap/core_ext/boolean"
if 1.class == Integer
  require "burlap/core_ext/integer"
else
  # require "burlap/core_ext/big_decimal"
  require "burlap/core_ext/fixnum"
end
require "burlap/core_ext/float"
require "burlap/core_ext/hash"
require "burlap/core_ext/nil"
require "burlap/core_ext/object"
require "burlap/core_ext/string"
require "burlap/core_ext/symbol"
require "burlap/core_ext/time"
