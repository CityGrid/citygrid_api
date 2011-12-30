class CityGrid
  class API
    class Advertising
      class Category < Advertising
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end