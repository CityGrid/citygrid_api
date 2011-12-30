class CityGrid
  class API
    class Advertising
      class AdGroup < Advertising
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end
