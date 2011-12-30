class CityGrid
  class API
    class Advertising
      class Budget < Advertising
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end