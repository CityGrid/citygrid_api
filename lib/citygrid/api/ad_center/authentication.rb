class CityGrid
  class API
    class AdCenter
      class Authentication < AdCenter
        server :ssl
        endpoint "/user/v2"
        
        def self.login options = {}
          handle_response do
            post(
              "#{endpoint}/login",
              :query => options
            )
          end
        end
      end
    end
  end
end