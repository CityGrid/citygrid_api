class CityGrid
  class API
    class Accounts
      class Login < Accounts
        def self.login options = {}
          request_and_handle :post,
            "#{endpoint}/login",
            :query => options,
            :headers => merge_headers()
        end
      end
    end
  end
end