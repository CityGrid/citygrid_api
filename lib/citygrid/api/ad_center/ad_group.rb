class CityGrid
  class API
    class AdCenter
      class AdGroup < AdCenter
        extend CityGrid::API::Mutatable
        extend Searchable
      end
    end
  end
end
