class CityGrid
  module API
    module AdCenter
      module Reports
        include CityGrid::API::Base
        base_uri qa_server_1

        class << self
          def endpoint
            "/report/adcenter/performance/v2/campaign"
          end

          def summary type, options = {}
            token = extract_auth_token options
            handle_response post(
              "#{endpoint}/#{type}",
              :body    => options.to_json,
              :headers => merge_headers("authToken" => token)
            )
          end
        end
      end
    end
  end
end