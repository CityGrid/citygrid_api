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
        request_and_handle method, endpoint, :query => query
      end

      def request_with_publisher options = {}
        request options.merge(:publisher => publisher)
      end

      def mutate options = {}
        token = extract_auth_token options
        request_and_handle :post,
          "#{endpoint}/mutate",
          :body    => options.to_json,
          :headers => merge_headers("authToken" => token)
      end

      def search options = {}
        token = extract_auth_token options
        request_and_handle :get, 
          "#{endpoint}/get",
          :query   => options,
          :headers => merge_headers("authToken" => token)

      end

      private
      def extract_auth_token options = {}
        options.delete(:token) || raise(MissingAuthToken)
      end

      def merge_headers options = {}
        {"Accept"       => "application/json",
          "Content-Type" => "Application/JSON"}.merge options
        end

        def convert_to_querystring hash
          hash.map do |k, v|
            key = URI.escape k.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
            val = URI.escape v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
            !value.empty? && !key.empty? ? "#{key}=#{value}" : nil
          end.compact.join("&")
        end

        HTTP_METHODS = {
          "put" => Net::HTTP::Put,
          "get" => Net::HTTP::Get,
          "post" => Net::HTTP::Post,
          "delete" => Net::HTTP::Delete,
          "head" => Net::HTTP::Head,
          "options" => Net::HTTP::Options
        }

        # Transform response into API::Response object
        # or throw exception if an error exists
        def request_and_handle http_method, path, options
          if http_method.is_a?(String) || http_method.is_a?(Symbol)
            http_method = HTTP_METHODS[http_method.to_s]
            raise "Unknown http method: #{http_method}" unless http_method
          end

          req_options = default_options.dup
          req_options = req_options.merge({:base_uri => CityGrid.config[server]}) if !base_uri && server
          req_options = req_options.merge(options)

          req = HTTParty::Request.new http_method, path, req_options
          
          error = nil
          
          begin 
            response = req.perform
          rescue => ex
            puts "Something went wrong with Request.perform"
            error = StandardError.new "Internal Error"
          rescue Psych::SyntaxError => ex
            puts "Something went wrong with Request.perform, Psych:SyntaxError"
            error = StandardError.new "Internal Error"
          end
          
          unless error
            if !response.parsed_response.is_a?(Hash)
              error = InvalidResponseFormat.new response
            elsif response["errors"]
              error = Error.new response["errors"], response
            else
              return CityGrid::API::Response.new response
            end
          end
          
          if error 
            puts "an error happened"
            puts req.to_json
            #raise error
          end
          
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
          ap req_options
          req.perform
          # super http_method, path, req_options
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
        attr_accessor :server_msg, :description
        def initialize response = nil
          # parse Tomcat error report
          if response.match /<title>Apache Tomcat.* - Error report<\/title>/
            response.scan(/<p><b>(message|description)<\/b> *<u>(.*?)<\/u><\/p>/).each do |match|
              case match[0]
              when "message"
                self.server_msg = match[1]
              when "description"
                self.description = match[1]       
              end
            end

            error_body = response.match(/<body>(.*?)<\/body>/m)[1]

            msg = <<-EOS
            Unexpected response format. Expected response to be a hash, but was instead:\n#{error_body}\n
            EOS

            super msg, error_body
          else
            msg = <<-EOS
            Unexpected response format. Expected response to be a hash, but was instead:\n#{response.parsed_response}\n
            EOS

            super msg, response
          end
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