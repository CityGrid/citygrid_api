class CityGrid
  class API
    class Accounts
      class Account < Accounts
        extend CityGrid::API::Mutatable
        extend CityGrid::API::Searchable
        
        # Adds new customer account to existing user
        # http://docs.prod.cs/display/citygridv2/Internal+-+Account#Internal-Account-AddNewCustomerAccounttoExistingUser
        define_action :import_to_cg, :post, "customer/mutate", :auth_token => true, :format => false

        # http://docs-dev.prod.cs/display/citygridv2/Internal+-+Account+Type
        define_action :account_type, :get, "get/type", :auth_token => true
      end
    end
  end
end