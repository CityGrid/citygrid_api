class CityGrid
  class API
    class Content
      class Places < Content
        base_uri "api.citygridmedia.com"
        endpoint "/content/places/v2"
        
        class << self
          def detail opts
            Detail.request opts
          end

          def search opts
            Search.request opts
          end
        end
      end
    end
  end
end

[
  "detail", "search"
].each do |x|
  require "citygrid/api/content/places/#{x}"  
end

