class CityGrid
  class API
    class AdCenter
      class Account < AdCenter
        # Adds new customer account to existing user
        # http://docs.prod.cs/display/citygridv2/Internal+-+Account#Internal-Account-AddNewCustomerAccounttoExistingUser
        def self.import_to_cg options = {}
          token = extract_auth_token options
          request_and_handle :post,
            "#{base_uri}/account/v2/customer/mutate",
            :body    => options.to_json,
            :headers => merge_headers("authToken" => token)
        end
      end
    end
  end
end