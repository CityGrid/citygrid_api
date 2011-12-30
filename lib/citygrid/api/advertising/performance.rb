class CityGrid
  class API
    class Advertising
      class Performance < Advertising
        class << self
          def summary type, options = {}
            token = extract_auth_token options
            request_and_handle :post,
              "#{endpoint}/#{type}",
              :body    => options.to_json,
              :headers => merge_headers("authToken" => token)
          end
        end
        
        define_action :daily, :post, "campaign/daily", :auth_token => true, :format => false
        define_action :actions, :post, "campaign/actions", :auth_token => true, :format => false
      end
    end
  end
end