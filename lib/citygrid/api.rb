require "httparty"
require "json"

class CityGrid
  class API 
    include HTTParty
    
    class << self   
      # server setting - :default or :ssl       
      def server val=nil
        return @server || (superclass.respond_to?(:server) ? superclass.server : nil) unless val
        @server = val
      end
      
      def hostname val=nil
        return @hostname || (superclass.respond_to?(:hostname) ? superclass.hostname : nil) unless val
        @hostname = val
      end
      
      def endpoint val=nil
        return @endpoint unless val
        @endpoint = val
      end

      def publisher
        CityGrid.publisher
      end

      def request options = {}
        method = (options.delete(:method) || :get).to_sym
        query  = options.merge :format => "json"
        handle_response send(method, endpoint, :query => query)
      end

      def request_with_publisher options = {}
        request options.merge(:publisher => publisher)
      end

      def mutate options = {}
        token = extract_auth_token options
        handle_response post(
          "#{endpoint}/mutate",
          :body    => options.to_json,
          :headers => merge_headers("authToken" => token)
        )
      end
      
      def search options = {}
        token = extract_auth_token options
        handle_response get(
          "#{endpoint}/get",
          :query   => options,
          :headers => merge_headers("authToken" => token)
        )
      end

      private

      # Transform response into API::Response object
      # or throw exception if an error exists
      def handle_response response
        if !response.parsed_response.is_a?(Hash)
          raise InvalidResponseFormat.new response

        elsif response["errors"]
          raise Error.new response["errors"], response

        else
          CityGrid::API::Response.new response
        end
      end

      def extract_auth_token options = {}
        options.delete(:token) || raise(MissingAuthToken)
      end

      def merge_headers options = {}
        {"Accept"       => "application/json",
         "Content-Type" => "application/json"}.merge options
      end

      def convert_to_querystring hash
        hash.map do |k, v|
          key = URI.escape k.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
          val = URI.escape v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
          !value.empty? && !key.empty? ? "#{key}=#{value}" : nil
        end.compact.join("&")
      end
      
      private
      
      def perform_request(http_method, path, options) #:nodoc:
        req_options = default_options.dup
        
        # if base_uri not set explicitly...
        unless base_uri 
        end
        
        req_options = req_options.merge({:base_uri => CityGrid.config[server]}) if !base_uri && server
        req_options = req_options.merge(options)
        req = HTTParty::Request.new http_method, path, req_options
        puts "**** URI: #{req.uri}"
        req.perform
        # super http_method, path, options
      end
    end
  
    # ERRORS
    class GenericError < StandardError
      attr_reader :httparty, :message

      def initialize msg, response = nil
        @message  = msg
        @httparty = response
      end
    end

    class Error < GenericError
      def initialize errors, response
        super errors.first["error"], response
      end
    end

    class InvalidResponseFormat < GenericError
      def initialize response = nil
        msg = <<-EOS
  Unexpected response format.  Expected response to be a hash, but was instead:
  \n#{response.parsed_response}\n
        EOS
        super msg, response
      end
    end

    class MissingAuthToken < GenericError
      def initialize
        super message
      end

      def message
        "Missing authToken - token is required"
      end
    end
  end
end