class CityGrid
  module DetailsMethods
    
    def request options = {}
      CityGrid::API::Content::Places.detail options
    end
  end

  class Details < Abstraction::Item
    include DetailsMethods

    private

    def preprocess response
      response.locations.first
    end
  end

  class MultiDetails < Abstraction::Collection
    include DetailsMethods

    private

    def preprocess response
      response.locations.map do |detail|
        Listing.new(detail).send(:load, false)
      end
    end
  end
end