class CityGrid
  class API
    class AdCenter
      class Budget < AdCenter
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end