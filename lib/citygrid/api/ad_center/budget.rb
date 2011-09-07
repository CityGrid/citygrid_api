class CityGrid
  module API
    module AdCenter
      module Budget
        include CityGrid::API::Base
        base_uri qa_server_1

        class << self
          def endpoint
            "/budget-suggestion/adcenter/budget/v2/recommendation/"
          end
        end
      end
    end
  end
end