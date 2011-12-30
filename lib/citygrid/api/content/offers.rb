class CityGrid
  class API
    class Content
      class Offers < Content
        define_action :where, :get, "search/where", :auth_token => false, :publisher => true, :client_ip => true
        define_action :places, :get, "search/places", :auth_token => false, :publisher => true, :client_ip => true
      end
    end
  end
end