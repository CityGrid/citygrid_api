# /mutate endpoint

class CityGrid
  class API
    module Mutatable
      def mutate options = {}
        token = extract_auth_token options
        request_and_handle :post,
          "#{endpoint}/mutate",
          :body    => options.to_json,
          :headers => merge_headers("authToken" => token)
      end
    end
  end
end