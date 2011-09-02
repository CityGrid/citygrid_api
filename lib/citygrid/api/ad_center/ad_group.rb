class CityGrid
  module API
    module AdCenter
      module AdGroup
        include CityGrid::API::Base
        base_uri qa_server

        class << self
          def endpoint
            "/adcenter/adgroup/v2/"
          end
        end
      end
    end
  end
end