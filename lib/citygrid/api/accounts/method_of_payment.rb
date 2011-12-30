class CityGrid
  class API
    class Accounts
      class MethodOfPayment < Accounts
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
      end
    end
  end
end