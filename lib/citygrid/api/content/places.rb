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
          
          def mutate options = {}
            token = extract_auth_token options
            handle_response do 
              post(
                "#{endpoint}/mutate",
                :body    => options.to_json,
                :headers => merge_headers("authToken" => token)
              )
            end
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

