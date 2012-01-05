class CityGrid
  class API
    class Advertising
      class Category < Advertising
        include CityGrid::API::Mutable
        include CityGrid::API::Searchable
      end
    end
  end
end