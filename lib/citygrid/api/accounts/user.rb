class CityGrid
  class API
    class Accounts
      class User < Accounts
        include CityGrid::API::Mutable
        include CityGrid::API::Searchable
        
        def self.login options = {}
          request_and_handle :post,
            "#{endpoint}/login",
            :query => options
        end
        
        # login behaves weird right now - expects string as body, not json encoded. 
        # define_action :login, :post, "login", :auth_token => false, :format => false        
        
        define_action :validate, :get, "validate", :auth_token => true, :format => false
      end
    end
  end
end