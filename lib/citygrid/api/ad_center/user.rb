class CityGrid
  class API
    class AdCenter
      class User < AdCenter
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end