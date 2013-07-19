class CityGrid
  class API
    class Accounts
      class Login < Accounts
        def self.login options = {}
          if endpoint.blank? and base_uri.blank?
            endpoint = CityGrid::API::Accounts::User.endpoint
            base_uri = CityGrid::API::Accounts::User.base_uri
          end
          request_and_handle :post,
            "#{endpoint}/login",
            :query => options,
            :headers => merge_headers()
        end
      end
    end
  end
end
