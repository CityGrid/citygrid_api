class CityGrid
  class API
    class Advertising
      class Offers < Advertising
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end