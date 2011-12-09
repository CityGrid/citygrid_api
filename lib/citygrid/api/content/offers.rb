class CityGrid
  class API
    class Content
      class Offers < Content
        @base_endpoint = "http://api.citygridmedia.com/content/offers/v2/search"
        endpoint @base_endpoint
        
        def self.where options = {}
          endpoint "#{@base_endpoint}/where"
          request_with_publisher options
        end
        
        def self.places options = {}
          endpoint "#{@base_endpoint}/places"
          request_with_publisher options
        end
      end
    end
  end
end