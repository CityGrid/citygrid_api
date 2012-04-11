class CityGrid
  class API
    class Ads
      class Custom < Ads
        define_action :where, :get, "where",
          :auth_token => false, 
          :publisher => true, 
          :client_ip => true, 
          :format => true
      end
    end
  end
end