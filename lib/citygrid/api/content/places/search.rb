class CityGrid
  module API
    module Content
      module Places
        module Search
          include CityGrid::API::Base

          class << self
            def endpoint
              "/places/v2/search/where"
            end
          end
        end
      end
    end
  end
end