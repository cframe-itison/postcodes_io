require "postcodes_io/version"
require "postcodes_io/postcodes_lookup"
require "postcodes_io/outcodes_lookup"
require "postcodes_io/postcode"
require "postcodes_io/outcode"

module Postcodes
  class IO
    include PostcodesLookup
    include OutcodesLookup
  end
end
