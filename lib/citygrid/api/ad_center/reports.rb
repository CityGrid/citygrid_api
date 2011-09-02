class CityGrid
  module API
    module AdCenter
      module Reports
        include CityGrid::API::Base
        base_uri qa_server

        class << self
          def endpoint
            "/report-ws/adcenter/performance/v2/campaign/daily/"
          end
        end
      end
    end
  end
end