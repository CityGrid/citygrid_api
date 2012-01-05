class CityGrid
  class API
    class Advertising
      class Billing <  Advertising
        include CityGrid::API::Mutable
        include CityGrid::API::Searchable
      end
    end
  end
end
