class CityGrid
  module API
    module AdCenter
      module Authentication
        include CityGrid::API::Base
        base_uri qa_server

        class << self
          def endpoint
            "/authentication/user/v2/login"
          end
        end
      end
    end
  end
end