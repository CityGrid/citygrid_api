class CityGrid
  class API
    class Accounts
      class Login < Accounts
        def self.login options = {}
          if self.endpoint.blank? and self.base_uri.blank?
            self.endpoint CityGrid::API::Accounts::User.endpoint
            self.base_uri CityGrid::API::Accounts::User.base_uri
          end
          request_and_handle :post,
            "#{self.endpoint}/login",
            :query => options,
            :headers => merge_headers()
        end
      end
    end
  end
end
