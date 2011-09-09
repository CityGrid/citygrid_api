class CityGrid
  module API
    module Content
      module Places
        include CityGrid::API::Base
        extend self

        def detail opts
          Detail.request opts
        end

        def search opts
          Search.request opts
        end

        def mutate opts = {}
          token = extract_auth_token opts
          handle_response post(
            qa_server_1 + "/places/adcenter/places/v2/mutate",
            :body    => opts.to_json,
            :headers => merge_headers("authToken" => token)
          )
        end
      end
    end
  end
end