class CityGrid
  class API
    class AdCenter
      class Image < AdCenter
        def self.preview options = {}
          token = extract_auth_token options
          request_and_handle :post,
            "#{base_uri}/adcenter/image/v2/preview",
            :body    => options.to_json,
            :headers => merge_headers("authToken" => token)
        end
      end
    end
  end
end