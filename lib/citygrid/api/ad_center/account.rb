class CityGrid
  class API
    class AdCenter
      class Account < AdCenter
        # Adds new customer account to existing user
        # http://docs.prod.cs/display/citygridv2/Internal+-+Account#Internal-Account-AddNewCustomerAccounttoExistingUser
        def self.import_to_cg options = {}
          mutate options
        end
      end
    end
  end
end