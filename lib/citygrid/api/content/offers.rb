class CityGrid
  module API
    module Content
      module Offers
        include CityGrid::API::Base

        class << self
          def endpoint
            "/offers/v2/search/places"
          end
        end
      end
    end
  end
end