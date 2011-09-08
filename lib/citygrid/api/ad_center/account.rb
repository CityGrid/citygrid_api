class CityGrid
  module API
    module AdCenter
      module Account
        include CityGrid::API::Base
        base_uri qa_server_2

        class << self
          def endpoint
            "/account/account/v2"
          end

          def create options = {}
            token = extract_auth_token options
            handle_response post(
              "#{base_uri}/account/account/customer/v2/mutate",
              :body    => options.to_json,
              :headers => {"authToken" => token}
            )
          end
        end
      end
    end
  end
end