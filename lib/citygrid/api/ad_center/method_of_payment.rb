class CityGrid
  class API
    class AdCenter
      class MethodOfPayment < AdCenter
        server :ssl
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end