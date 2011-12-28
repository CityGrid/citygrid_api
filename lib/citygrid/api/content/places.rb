class CityGrid
  class API
    class Content
      class Places < Content
        endpoint "/content/places/v2"
        
        extend CityGrid::API::Mutatable
        
        define_action :detail, :get, "detail", false, true, true
        define_action :search, :get, "search/where", false, true, true
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/places/*.rb'].each {|file| require file }