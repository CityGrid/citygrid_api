class CityGrid
  class Search < Abstraction::Collection
    
    def request options = {}
      CityGrid::API::Content::Places.search options
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