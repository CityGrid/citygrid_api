# Ruby 1.9.2 has YAML::ENGINE and will blow up if you don't define yamler
# Ruby 1.8.7 doesn't have YAML::ENGINE, this should take care of both cases
YAML::ENGINE.yamler= 'syck' if defined?(YAML::ENGINE)

# load monkey patches
require "string_ext"
require "request_ext"

class CityGrid
  class << self
    def publisher= code
      @publisher = code
    end
    
    def publisher
      raise PublisherNotConfigured if !defined?(@publisher) || @publisher.nil?
      @publisher
    end
    
    # whether api calls will throw errors or fail silently
    # by default, we will raise errors
    def raise_errors= v
      @raise_errors = v
    end
    
    def raise_errors? 
      !defined?(@raise_errors) || @raise_errors
    end

    def use_vcr= v
      @use_vcr = v
    end
    
    def use_vcr?
      defined?(VCR) && defined?(@use_vcr) && @use_vcr
    end
    
    def search opts = {}
      Search.new opts
    end

    def find listing_id
      Listing.new("id" => listing_id).send(:load)
    end

    def offers opts
      Offers.new opts
    end

    def reviews opts
      Reviews.new opts
    end
    
    def session username, password
      Session.login username, password
    end
    
    def authenticate params
      API::Accounts::User.login params
    end
    alias_method :login, :authenticate
    
    # load in configs
    # see citygrid_api.yml.sample for format
    def load_config file_path, env = nil
      config = YAML.load_file(file_path)
      
      defaults = config["defaults"]
      
      default_hostname = "http://#{defaults["hostname"]}"
      ssl_hostname = "https://#{defaults["ssl_hostname"]}"

      config["api"].each do |n, endpoints|
        # namespace would be ad_center or content
        namespace = API.const_get n.camelcase

        endpoints.each do |k, v|
          # camelcase classname
          klass = namespace.const_get(k.camelcase)
          
          if v.is_a? String
            # if value is a plain String, that's the endpoint
            endpoint = v.start_with?("/") ? v : "/#{v}"
            klass.endpoint endpoint
            klass.base_uri default_hostname
          elsif v.is_a? Hash
            # if value is a Hash, fetch endpoint
            # if hostname is set, use it
            # otherwise if ssl is set then use ssl_hostname. fallback to default_hostname
            hostname = v["hostname"] || (v["ssl"] ? ssl_hostname : default_hostname)
            throw ParseConfigurationError.new file_path, "No endpoint defined for #{k}" unless v["endpoint"]
            endpoint = v["endpoint"].start_with?("/") ? v["endpoint"] : "/#{v["endpoint"]}" 
            klass.endpoint endpoint
            klass.base_uri hostname
          else 
            # should not get here. value should be String or Hash
            throw ParseConfigurationError.new file_path, "Invalid value type for #{k}"
          end
          
          # puts "#{klass.name} => #{klass.base_uri} : #{klass.endpoint}"
        end
      end
    end
  end

  # Errors
  # --------------- #
  class PublisherNotConfigured < StandardError
    def initialize
      super "Publisher hasn't been configured. Run 'CityGrid.publisher=<code>'"
    end
  end
  
  class EndpointsNotConfigured < StandardError
    def initialize
      super "Endpoint is not properly configured. Run 'CityGrid.load_config'"
    end
  end
  
  class ParseConfigurationError < StandardError
    def initialize path, msg = nil
      super msg ? "#{msg} at '#{path}'" : "Error parsing configuration file at '#{path}'"
    end
  end
  
end

require "citygrid/abstraction"
require "citygrid/api"
require "yaml"

require "citygrid/api/mutable"
require "citygrid/api/searchable"

require "citygrid/search"
require "citygrid/reviews"
require "citygrid/offers"
require "citygrid/details"
require "citygrid/listing"
require "citygrid/session"

require "citygrid/api/response"

require "citygrid/api/accounts"
require "citygrid/api/advertising"
require "citygrid/api/content"

require "request_ext"