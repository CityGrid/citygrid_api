class CityGrid
  class API
    class Content
      class Offers < Content
        base_uri "api.citygridmedia.com/content"
        endpoint "#{base_uri}/offers/v2/search/where"
        
        def self.where options = {}
          request_with_publisher options.merge(:method => :get)
        end
      end
    end
  end
end