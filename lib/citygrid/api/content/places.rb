require "citygrid/api/content/places/detail"
require "citygrid/api/content/places/search"

class CityGrid
  module API
    module Content
      module Places
        extend self

        def detail opts
          Detail.request opts
        end

        def search opts
          Search.request opts
        end
      end
    end
  end
end