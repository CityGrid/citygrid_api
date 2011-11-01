class CityGrid
  class API
    class AdCenter
      class Authentication < AdCenter
        def self.login options = {}
          request_and_handle :post,
            "#{endpoint}/login",
            :query => options
        end
        
        def self.validate options = {}
          request_and_handle :get,
            "#{endpoint}/validate",
            :query => options,
            :headers => merge_headers
        end
      end
    end
  end
end