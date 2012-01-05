class CityGrid
  class API
    class Content
      class Response < Content
        extend CityGrid::API::Mutatable
        define_action :get, :get, "get",
          :auth_token => true, 
          :publisher => true, 
          :client_ip => true, 
          :format => true
      end
    end
  end
end