class CityGrid
  module API
    module AdCenter
      module Campaign
        include CityGrid::API::Base
        base_uri qa_server_2

        class << self
          def endpoint
            "/campaign/adcenter/campaign/v2"
          end
        end
      end
    end
  end
end