class CityGrid
  class API
    class Advertising
      class PlacesGet < Advertising
        include CityGrid::API::Searchable
      end
    end
  end
end
