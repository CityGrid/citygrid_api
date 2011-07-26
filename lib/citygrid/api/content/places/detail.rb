class CityGrid
  module API
    module Content
      module Places
        module Detail
          include CityGrid::API::Base

          class << self
            def endpoint
              "/places/v2/detail"
            end
          end
        end
      end
    end
  end
end