class CityGrid
  class API
    class AdCenter
      class Reports < AdCenter
        endpoint "/adcenter/performance/v2/campaign"
        
        class << self
          def summary type, options = {}
            token = extract_auth_token options
            request_and_handle :post,
              "#{endpoint}/#{type}",
              :body    => options.to_json,
              :headers => merge_headers("authToken" => token)

          end
        end
      end
    end
  end
end