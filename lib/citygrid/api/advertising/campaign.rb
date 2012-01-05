class CityGrid
  class API
    class Advertising
      class Campaign < Advertising
        include CityGrid::API::Mutable
        include CityGrid::API::Searchable
      end
    end
  end
end