class CityGrid
  module API
    module AdCenter
      module MethodOfPayment
        include CityGrid::API::Base
        base_uri qa_server_1

        class << self
          def endpoint
            "/mop/adcenter/account/v2/mop"
          end
        end
      end
    end
  end
end