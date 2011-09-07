class CityGrid
  module API
    module AdCenter
      module AdGroupCriterion
        include CityGrid::API::Base
        base_uri qa_server_2

        class << self
          def endpoint
            "/adgroupcriterion/adcenter/adgroupcriterion/v2/"
          end
        end
      end
    end
  end
end