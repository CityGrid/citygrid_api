class CityGrid
  class API
    class Advertising
      class Campaign < Advertising
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end