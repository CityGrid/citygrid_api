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
            return safe_options.merge({ :body => to_merge })
          end
        # If the parameters are contained in the :query node of the options hash
        elsif options[:query] && !options[:query].nil?
          to_merge = safe_options[:query].merge(unsafe_params.select { |k| safe_options[:query].keys.include? k })
          return safe_options.merge({ :query => to_merge })
        else
          return options
        end
      end

      def parse_multiple_responses response
        parsing = response.values.select{ |x| x.is_a? Array }.first
        if parsing.nil? || parsing == []
          #pp "Response was too hard to parse... letting it through..."
          return parsing
        elsif parsing != nil && parsing != []
          if parsing[0]["response"]
            parsing = [parsing[0]["response"]["code"], parsing[0]["response"]["message"]]
            return parsing
          else
            # this accomodates geocode response which does not contain a response node
            #pp "Response was too hard to parse... letting it through..."
            return nil
          end
        else
          # We should figure out a better way to do this
          raise CityGridExceptions::APIError.new "Received a JSON error code but it could not be parsed: #{response}"
        end
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

        # Sanitized request for logs
        safe_req_options = strip_unsafe_params(http_method, req_options)
        req_to_output = HTTParty::Request.new http_method, path, safe_req_options

        begin
          response = req.perform
        rescue => ex
          raise CityGridExceptions::RequestError.new req, ex
        ensure
          if defined?(Rails.logger)
            Rails.logger.info req_to_output.to_curl
          else
            puts req_to_output.to_curl
          end
        end

        begin 
          # catch unparsable responses (html etc)
          if !response.parsed_response.is_a?(Hash)
            #pp "[gem] the response was unparsable (response was not a hash)"
            raise CityGridExceptions::ResponseParseError.new req, response
          # catch responses not in new response format
          elsif response["errors"]
            #pp "[gem] An error in the old response format was caught.  Raising a general response error..."
            raise CityGridExceptions::ResponseError.new req, response["errors"], response

          # Parse and handle new response codes 
          elsif (response["response"] && response["response"]["code"] != "SUCCESS") && 
                (response["response"] && response["response"]["code"] != 200) && 
                (response["response"] && response["response"]["code"] != 400) 
            error_code = response["response"]["code"]
            #pp "[gem] The response was contained in the first level of the response hash.  Below:"
            #pp response
            #pp "found error code: #{error_code}"
            #pp "****************************************************************************"
            raise CityGridExceptions.appropriate_error(error_code).new req, response, response["response"]["message"].to_s #+ " " + CityGridExceptions.print_superclasses(error_code)
          # if the response is a nested hash/nested hash containing arrays
          elsif response["totalNumEntries"] && response["response"].nil?
            #pp "[gem] now parsing a response with multiple entries: #{response}"
            error_code = parse_multiple_responses(response)
            #pp "the error code that came back is #{error_code}"
            if error_code.nil? || error_code == []
              #pp "[gem] passing over this for now"
              return CityGrid::API::Response.new response # pass over for now
            elsif error_code[0] == "SUCCESS" || error_code[0] == 200 || error_code[0] == 400
              return CityGrid::API::Response.new response
            else 
              #pp "[gem] we found an error and it was #{error_code[1]}"
                raise CityGridExceptions.appropriate_error(error_code[0]).new req, response, error_code[1].to_s  + " "# + CityGridExceptions.print_superclasses(error_code[0])
            end
          else
            return CityGrid::API::Response.new response
          end
        rescue => ex
          pp "The gem threw an error: #{ex}"
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
