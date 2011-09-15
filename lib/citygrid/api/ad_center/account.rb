class CityGrid
  module API
    module AdCenter
      module Account
        include CityGrid::API::Base
        base_uri qa_server_ssl

        class << self
          def endpoint
            "/account/v2"
          end

          # Adds new customer account to existing user
          # http://docs.prod.cs/display/citygridv2/Internal+-+Account#Internal-Account-AddNewCustomerAccounttoExistingUser
          def import_to_cg options = {}
            token = extract_auth_token options
            handle_response post(
              "#{base_uri}/account/account/customer/v2/mutate",
              :body    => options.to_json,
              :headers => merge_headers("authToken" => token)
            )
          end
        end
      end
    end
  end
end