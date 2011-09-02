class CityGrid
  module API
    module AdCenter
      module Category
        include CityGrid::API::Base
        base_uri qa_server

        class << self
          def endpoint
            "/category/adcenter/categories/v2"
          end
        end
      end
    end
  end
end