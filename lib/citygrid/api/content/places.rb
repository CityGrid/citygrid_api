class CityGrid
  class API
    class Content
      class Places < Content
        include CityGrid::API::Mutable
        
        define_action :detail, :get, "detail", :auth_token => false, :publisher => true, :client_ip => true
        define_action :search, :get, "search/where", :auth_token => false, :publisher => true, :client_ip => true
        define_action :searchlatlon, :get, "search/latlon", :auth_token => false, :publisher => true, :client_ip => true
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/places/*.rb'].each {|file| require file }
