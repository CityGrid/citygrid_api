class CityGrid
  module DetailsMethods
    def api
      CityGrid::API::Content::Places::Detail
    end

    def request opts = {}
      api.request_with_publisher opts.merge(:client_ip => "192.168.0.1")
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