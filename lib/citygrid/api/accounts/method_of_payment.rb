class CityGrid
  class API
    class Accounts
      class MethodOfPayment < Accounts
        include CityGrid::API::Mutable
        include CityGrid::API::Searchable
      end
    end
  end
end