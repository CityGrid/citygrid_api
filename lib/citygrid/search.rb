class CityGrid
  class Search < Abstraction::Collection
    def api
      CityGrid::API::Content::Places::Search
    end

    def request opts = {}
      api.request_with_publisher opts
    end

    private

    def preprocess response
      return nil unless response && response.results && response.results.locations

      response.results.locations.map do |attrs|
        Listing.new attrs
      end
    end
  end
end