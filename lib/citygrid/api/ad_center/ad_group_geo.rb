class CityGrid
  module API
    module AdCenter
      module AdGroupGeo
        include CityGrid::API::Base
        base_uri qa_server_1

        class << self
          def endpoint
            "/geolocation/adcenter/geolocationservice/v2/address"
          end
        end
      end
    end
  end
end