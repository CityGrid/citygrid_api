require "httparty"
require "json"

class CityGrid
  class API 
    include HTTParty
    format :json
    #debug_output $stderr

    DEFAULT_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "Application/JSON"}
    
    class << self   
      def define_action name, method, action, auth_required = true, publisher_required = false, ip_required = false
        
        define_singleton_method name.intern do |*args|
          options = args.first.clone || {}
          params = {}
          
          token = options.delete :token
          
          headers = API::DEFAULT_HEADERS.clone
          
          headers.merge! "authToken" => token if auth_required

          options.merge! "format" => "json"
          options.merge! "publisher" => CityGrid.publisher if publisher_required  
          options.merge! "client_ip" => "192.168.0.1" if ip_required  
          
          params[:headers] = headers
          
          case method
          when :post
            params[:body] = options.to_json
          when :get
            params[:query] = options
          end
          
          request_and_handle method.intern, "#{endpoint}/#{action}", params
        end
      end
      
      def endpoint val = nil
        return @endpoint unless val
        @endpoint = val
      end

      def request options = {}
        method = (options.delete(:method) || :get).to_sym
        query  = options.merge :format => :json
        request_and_handle method, endpoint, :query => query
      end

      private
        def extract_auth_token options = {}
          options.delete(:token) #|| raise(MissingAuthToken)
        end
        
        def merge_headers options = {}
          DEFAULT_HEADERS.merge options
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
          req_options = req_options.merge(options)

          req = HTTParty::Request.new http_method, path, req_options
          error = nil

          begin 
            response = req.perform
          rescue => ex
            puts "Something went wrong with Request.perform"
            error = ex
          rescue Psych::SyntaxError => ex
            puts "Something went wrong with Request.perform, Psych:SyntaxError"
            error = ex
          end
          
          if defined?(Rails.logger)
            Rails.logger.info req.to_curl
          else
            puts req.to_curl
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
            ap error
            #raise error
          end
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