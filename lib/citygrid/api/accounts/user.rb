class CityGrid
  class API
    class Accounts
      class User < Accounts
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
        
        define_action :login, :post, "login", :auth_token => false, :format => false        
        define_action :validate, :get, "validate", :auth_token => true, :format => false
      end
    end
  end
end