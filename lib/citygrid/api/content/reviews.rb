class CityGrid
  module API
    module Content
      module Reviews
        include CityGrid::API::Base

        class << self
          def endpoint
            "/reviews/v2/search/where"
          end
        end
      end
    end
  end
end