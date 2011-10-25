class CityGrid
  class API
    class AdCenter
      class Authentication < AdCenter
        def self.login options = {}
          request_and_handle :post,
            "#{endpoint}/login",
            :query => options
        end
      end
    end
  end
end