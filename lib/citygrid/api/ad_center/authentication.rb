class CityGrid
  module API
    module AdCenter
      module Authentication
        include CityGrid::API::Base
        base_uri qa_server_1

        class << self
          def endpoint
            "/authentication/user/v2/login"
          end
        end
      end
    end
  end
end