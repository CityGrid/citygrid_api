require 'base64'

class CityGrid
  class API
    class AdCenter
      class Image < AdCenter
        def self.upload user_id, name, type, image_path, options = {}
          token = extract_auth_token options
          image_data = Base64.encode64(File.open(image_path).read.to_s).gsub(/\n/, "")
          format = options[:format] || image_path.split(".").last
          request_and_handle :post,
            "#{base_uri}/#{endpoint}/upload",
            :body => {"mutateOperationListResource" => [
              {
                "operand" => {
                	"image_type" => type,
                	"image_name" => name,
                	"image_format" => format,
                	"image" => Base64.strict_encode64(File.open(image_path).read.to_s)
                  },
                "operator" => "ADD",
                "userId" => user_id
              }
            ]}.to_json,
            :headers => merge_headers("authToken" => token)
        end
      end
    end
  end
end