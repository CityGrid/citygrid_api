class CityGrid
  class API
    class Content
      class Response < Content
        include CityGrid::API::Mutable
        define_action :get, :get, "get",
          :auth_token => true, 
          :publisher => true, 
          :client_ip => true, 
          :format => true
      end
    end
  end
end