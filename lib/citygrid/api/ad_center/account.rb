class CityGrid
  module API
    module AdCenter
      module Account
        include CityGrid::API::Base
        base_uri qa_server

        class << self
          def endpoint
            "/account/account/v2/"
          end
        end
      end
    end
  end
end