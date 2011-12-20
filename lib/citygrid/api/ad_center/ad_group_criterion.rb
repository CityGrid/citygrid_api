class CityGrid
  class API
    class AdCenter
      class AdGroupCriterion < AdCenter
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end