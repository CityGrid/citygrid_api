class CityGrid
  module API
    module AdCenter
      module AdGroupAd
        include CityGrid::API::Base
        base_uri qa_server

        class << self
          def endpoint
            "/adgroupad/adcenter/adgroupad/v2/"
          end
        end
      end
    end
  end
end