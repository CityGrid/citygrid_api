class CityGrid
  class API
    class Advertising
      class AdGroupCriterion < Advertising
        include CityGrid::API::Mutable
        include CityGrid::API::Searchable
      end
    end
  end
end