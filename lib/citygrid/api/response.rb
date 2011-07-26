class CityGrid
  module API
    # Creates SuperHash from parsed_response
    # Stores response object in @response.
    # ------------------------------------ #
    class Response < CityGrid::Abstraction::SuperHash
      attr_reader :httparty

      def self.new httparty_response
        resp = super httparty_response.parsed_response
        resp.instance_variable_set "@httparty", httparty_response
        resp
      end
    end
  end
end