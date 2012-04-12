require 'base64'

class CityGrid
  class API
    class Advertising
      class Image < Advertising
        def self.upload name, type, image_path, options = {}
          token = extract_auth_token options
          image_data = Base64.encode64(File.open(image_path).read.to_s).gsub(/\n/, "")
          format = options[:format] || image_path.split(".").last
          request_and_handle :post,
            "#{base_uri}/#{endpoint}/upload",
            :body => {"mutateOperationListResource" => [
              {
                "operand" => {
                	"imageType" => type,
                	"imageName" => name,
                	"imageFormat" => format,
                	"image" => image_data
                  },
                "operator" => "ADD"
              }
            ]}.to_json,
            :headers => merge_headers("authToken" => token)
        end
      end
    end
  end
end