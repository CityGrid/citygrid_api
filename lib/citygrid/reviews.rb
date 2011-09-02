class CityGrid
  class Reviews < Abstraction::Collection
    def api
      CityGrid::API::Content::Reviews
    end

    def request opts = {}
      api.request_with_publisher opts
    end

    def total_hits
      raw["results"]["total_hits"]
    end

    private

    def preprocess response
      response.results.reviews
    end
  end
end