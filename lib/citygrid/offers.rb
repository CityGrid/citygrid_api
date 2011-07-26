class CityGrid
  class Offers < Abstraction::Collection
    def api
      CityGrid::API::Content::Offers
    end

    private

    def preprocess response
      response.results.offers
    end
  end
end