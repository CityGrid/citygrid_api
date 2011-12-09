class CityGrid
  class API
    module Searchable
      def search options = {}
        token = extract_auth_token options
        request_and_handle :get, 
          "#{endpoint}/get",
          :query   => options,
          :headers => merge_headers("authToken" => token)
      end
    end
  end
end