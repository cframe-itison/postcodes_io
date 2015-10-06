require 'excon'
require 'json'
require 'postcodes_io/outcode'

module Outcodes
  module OutcodesLookup


    def lookup_outcodes(*outcodes)
      outcodes.flatten!
      if outcodes.count > 1
        lookup_multiple outcodes
      else
        lookup_individual outcodes.first
      end
    end
          

    private

    def lookup_individual(outcode)
      outcode = remove_whitespace outcode
      response = Excon.get("https://api.postcodes.io/postcodes/#{outcode}")

      unless response.status == 404
        parsed_response = JSON.parse(response.body)
        return Postcodes::Outcode.new(parsed_response['result'])
      end
      return nil
    end

    def lookup_multiple(outcodes)
      payload = {outcodes: outcodes.map {|o| remove_whitespace o}}
      response = Excon.post(
        "https://api.postcodes.io/outcodes",
         body: payload.to_json,
         headers: {'Content-Type' => 'application/json'}
         )

      process_response(response) do |r|
        return r['result'].map do |result|
          Postcodes::Outcode.new(result['result'])
        end
      end
    end

    def remove_whitespace(string)
      string.gsub(/\s+/, '') # remove any whitespace. m1 1ab => m11ab
    end

    def process_response(response, &block)
      unless response.status == 404
        yield JSON.parse(response.body)
      end
      nil
    end

  end
end
