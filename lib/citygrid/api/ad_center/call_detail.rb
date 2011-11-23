class CityGrid
  class API
    class AdCenter
      class CallDetail < AdCenter
        class << self
          def get by, options = {}
            token = extract_auth_token options
            request_and_handle :post,
              "#{endpoint}/#{by}",
              :body    => options.to_json,
              :headers => merge_headers("authToken" => token)
          end
          
          def note options = {}
            token = extract_auth_token options
            request_and_handle :post,
              "#{endpoint}/note",
              :body    => options.to_json,
              :headers => merge_headers("authToken" => token)
          end
        end
      end
    end
  end
end