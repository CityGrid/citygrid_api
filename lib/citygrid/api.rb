require "httparty"
require "json"
require "citygrid/citygrid_exceptions"
require "pp"

class CityGrid
  class API 
    include HTTParty
    include CityGridExceptions
    #debug_output $stderr

    DEFAULT_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "Application/JSON"}
    
    DEFAULT_ACTION_OPTIONS = {
      :auth_token => false,
      :format     => true,
      :publisher  => false,
      :client_ip  => false
    }
    
    class << self   
      def define_action name, method, action, define_options = {}
        # options: 
        #    auth_token: pass along auth_token
        #    publisher: pass CityGrid.publisher, currently needed for content APIs
        #    ip: pass IP, needed for content
        #    format: pass JSON flag 
        
        define_options = DEFAULT_ACTION_OPTIONS.merge define_options

        define_singleton_method name.intern do |*args|
          options = args.first.clone || {}
          params = {}
          
          token = options.delete :token
          
          headers = API::DEFAULT_HEADERS.clone

          headers.merge! "authToken" => token if define_options[:auth_token] && token

          options.merge! "format"     => "json" if define_options[:format]
          options.merge! "publisher"  => CityGrid.publisher if define_options[:publisher]
          options.merge! "client_ip"  => "192.168.0.1" if define_options[:client_ip]
          
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

      def strip_unsafe_params method, options
        safe_options = options.dup
        to_merge = {}
        unsafe_params = { 
                          :password => "FILTERED", "securityCode" => "FILTERED",
                          "cardNumber" => "FILTERED", "expirationMonth" => "FILTERED",
                          "expirationYear" => "FILTERED"
                        }
        # If the parameters are contained in the :body node of the options hash
        if options[:body] && !options[:body].nil?
          # Convert the inner JSON before doing any work
          safe_options[:body] = JSON.parse(safe_options[:body])

          # This handles the mop query format
          if safe_options[:body]["mutateOperationListResource"] && 
             safe_options[:body]["mutateOperationListResource"][0] &&
             safe_options[:body]["mutateOperationListResource"][0]["operand"]
            # All the sensitive fields are located in this path
            target_hash = safe_options[:body]["mutateOperationListResource"][0]["operand"]
            # Strip any elements from the unsafe params hash that aren't in options and merge
            to_merge = target_hash.merge(unsafe_params.select { |k| target_hash.keys.include?(k) })
            # Merge the clean operand hash back into the body
            safe_options[:body]["mutateOperationListResource"][0]["operand"].merge!(to_merge)
            # Convert the body key back to json before returning
            safe_options[:body] = safe_options[:body].to_json
            return safe_options
          # Any other format with :body node 
          else
            to_merge = safe_options[:body].merge(unsafe_params.select { |k| safe_options[:body].keys.include? k })
            safe_options.merge!({ :body => to_merge })
            safe_options[:body] = safe_options[:body].to_json
            return safe_options
          end
        # If the parameters are contained in the :query node of the options hash
        elsif options[:query] && !options[:query].nil?
          to_merge = safe_options[:query].merge(unsafe_params.select { |k| safe_options[:query].keys.include? k })
          return safe_options.merge({ :query => to_merge })
        else
          return options
        end
      end

      def parse_response_status response_body
        status = nil
        if response_body["response"] || response_body["responseStatus"]
          status = response_body["response"] || response_body["responseStatus"]
        elsif response_body["errors"]
          # make this throw some kind of content API error
          errors = "" 
          response_body["errors"].each { |e| errors += "#{e["error"]} " }
          status = { "code" => "CONTENT_API_ERROR", "message" => errors  }
        elsif response_body["code"] && response_body["message"]
          status = response_body
        else
          response_body.each_value do |value|
            case value
              when Array
                value.each do |inner_value|
                  if inner_value["response"] || inner_value["responseStatus"]
                    status = inner_value["response"] || inner_value["responseStatus"]
                  end
                end
              when Hash
                if value["response"] || value["responseStatus"]
                  status = value["response"] || value["responseStatus"]
                end
            end
          end
        end
        return status
      end

      # Transform response into API::Response object
      # or throw exception if an error exists
      def request_and_handle http_method, path, options
        if http_method.is_a?(String) || http_method.is_a?(Symbol)
          http_method = HTTP_METHODS[http_method.to_s]
          raise "Unknown http method: #{http_method}" unless http_method
        end
      
        req_options = default_options.dup
        req_options = req_options.merge(options)
        
        raise ConfigurationError.new "No endpoint defined" if !path || path.empty?
        raise ConfigurationError.new "No hostname defined" if !req_options[:base_uri] || req_options[:base_uri].empty?
        
        # prepare request
        req = HTTParty::Request.new http_method, path, req_options
        req.options[:timeout] = CityGrid.custom_timeout if req.options && CityGrid.custom_timeout_set?

        # Sanitized request for logs
        safe_req_options = strip_unsafe_params(http_method, req_options)
        req_to_output = HTTParty::Request.new http_method, path, safe_req_options
        req_for_airbrake = { :method => http_method, :path => path, :options => safe_req_options }

        begin
          response = req.perform
        rescue => ex  
          if defined?(Rails.logger)
            Rails.logger.error safe_req_options
            Rails.logger.error req_to_output
            Rails.logger.error req_for_airbrake
            Rails.logger.error ex
          end
          raise CityGridExceptions::RequestError.new req_for_airbrake, nil, ex.message, req_to_output.to_curl
        ensure
          if CityGrid.print_curls? 
            if defined?(Rails.logger)
              Rails.logger.info req_to_output.to_curl
              puts req_to_output.to_curl
            else
              puts req_to_output.to_curl
            end
          end
        end

        response_status = parse_response_status response
        
        begin 
          # catch unparsable responses (html etc)
          if !response.parsed_response.is_a?(Hash)
            #pp "[gem] the response was unparsable (response was not a hash)"
            raise CityGridExceptions::ResponseParseError.new req_for_airbrake, response, "the response was unparsable (response was not a hash)", req_to_output.to_curl
          else
            # Parse and handle new response codes 
            if !response_status.nil? && response_status["code"] != "SUCCESS" && response_status["code"] != 200
              raise CityGridExceptions.appropriate_error(response_status["code"]).new req_for_airbrake, response, response_status["message"].to_s, req_to_output.to_curl
            else
              return CityGrid::API::Response.new response
            end
          end
        rescue => ex
          pp "API ERROR: #{ex}"
          raise ex if CityGrid.raise_errors?
        end
      end

   # Errors

      class MUSHPendingChanges <StandardError
        def initialize message = "The are currently pending changes in the mush.  Cannot update."
          super message
        end
      end
      
      # class InvalidAuthToken < StandardError
      #   def initialize message = "Invalid Token or Expired"
      #     super message
      #   end
      # end

      # class MissingAuthToken < StandardError
      #   def initialize
      #     super "Missing authToken - token is required"
      #   end
      # end
      
      class ConfigurationError < StandardError
        def initialize message = "Invalid Configuration"
          super message
        end
      end
    end
  end
end
