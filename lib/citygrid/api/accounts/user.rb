class CityGrid
  class API
    class Accounts
      class User < Accounts
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
        
        def self.login options = {}
          request_and_handle :post,
            "#{endpoint}/login",
            :query => options
        end
        
        define_action :validate, :get, "validate", :auth_token => true
      end
    end
  end
end