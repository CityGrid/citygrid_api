class CityGrid
  class Offers < Abstraction::Collection
    def request opts = {}
      CityGrid::API::Content::Offers.search opts
    end

    private

    def preprocess response
      response.results.offers
    end
  end
end