class CityGrid
  module API
    module AdCenter
      module Authentication
        include CityGrid::API::Base
        base_uri qa_server_ssl

        class << self
          def endpoint
            "/user/v2/login"
          end
        end
      end
    end
  end
end