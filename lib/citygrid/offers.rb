class CityGrid
  class Offers < Abstraction::Collection
    def api
      CityGrid::API::Content::Offers
    end

    def request opts = {}
      api.request_with_publisher opts
    end

    private

    def preprocess response
      response.results.offers
    end
  end
end