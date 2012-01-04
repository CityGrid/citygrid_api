class CityGrid
  class API
    class Content
      class Reviews < Content
        define_action :where, :get, "search/where",
          :auth_token => false, 
          :publisher => true, 
          :client_ip => true, 
          :format => true
      end
    end
  end
end