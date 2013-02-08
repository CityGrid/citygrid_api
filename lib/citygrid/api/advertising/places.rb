class CityGrid
  class API
    class Advertising
      class Places < Advertising
        include CityGrid::API::Mutable
        include CityGrid::API::Searchable
        define_action :status, :get, "status", :auth_token => true, :format => false
      end
    end
  end
end