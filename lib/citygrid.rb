# Ruby 1.9.2 has YAML::ENGINE and will blow up if you don't define yamler
# Ruby 1.8.7 doesn't have YAML::ENGINE, this should take care of both cases
YAML::ENGINE.yamler= 'syck' if defined?(YAML::ENGINE)

class CityGrid
  class << self
    def publisher= code
      @publisher = code
    end
    
    def publisher
      raise PublisherNotConfigured if !defined?(@publisher) || @publisher.nil?
      @publisher
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

    def authenticate params
      API::AdCenter::Authentication.login params
    end
    alias_method :login, :authenticate
    
    # config info
    def load_config file_path, env = nil
      config = YAML.load_file(file_path)
      
      defaults = config["defaults"]
      
      default_hostname = "http://#{defaults["hostname"]}"
      ssl_hostname = "https://#{defaults["ssl_hostname"]}"
      
      config["endpoints"].each do |k, v|
        # camelcase classname
        classname = k.gsub(/(_(.))/) { $2.upcase}.gsub(/^(.)/) { $1.upcase }
        klass = API::AdCenter.const_get(classname)
        if v.is_a? String
          endpoint = v.start_with?("/") ? v : "/#{v}"
          klass.endpoint endpoint
          klass.base_uri default_hostname
        elsif v.is_a? Hash
          hostname = v["hostname"] || (v["ssl"] ? ssl_hostname : default_hostname)

          endpoint = v["endpoint"].start_with?("/") ? v["endpoint"] : "/#{v["endpoint"]}" 
          klass.endpoint endpoint
          klass.base_uri hostname
        else 
          # should not get here
        end
      end
    end
    
    def config
      raise EndpointsNotConfigured unless @config && !@config.nil?
      @config
    end
    
    def set_endpoints config_file
      File.open config_file, "r" do |file|
        while line = file.gets
          api, endpoint = line.split("=").map{|x| x.chomp}
          endpoint = "/#{endpoint}" unless endpoint.start_with?("/")
          klass = CLASS_MAPPING[api]
          next unless klass
          
          klass.endpoint endpoint
        end
      end
    end
    
    def set_env config_file
      File.open config_file, "r" do |file|
        while line = file.gets
          api, host = line.split("=").map{|x| x.chomp}
          host = "http://#{host}" unless host.start_with?("http")
          klass = CLASS_MAPPING[api]
          next unless klass
          
          klass.base_uri host
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
      super "Endpoints haven't been configured. Run 'CityGrid.load_config'"
    end
  end
end

require "citygrid/abstraction"
require "citygrid/api"

require "citygrid/search"
require "citygrid/reviews"
require "citygrid/offers"
require "citygrid/details"
require "citygrid/listing"

require "citygrid/api/response"
require "citygrid/api/ad_center"
require "citygrid/api/content"

require "request_ext"

class CityGrid
  CLASS_MAPPING = {
    "account"               => CityGrid::API::AdCenter::Account,
    "accountmanager"        => CityGrid::API::AdCenter::AccountManager,
    "adgroup"               => CityGrid::API::AdCenter::AdGroup,
    "adgroupad"             => CityGrid::API::AdCenter::AdGroupAd,
    "adgroupgeo"            => CityGrid::API::AdCenter::AdGroupGeo,
    "billing"               => CityGrid::API::AdCenter::Billing,
    "adgroupcriterion"      => CityGrid::API::AdCenter::AdGroupCriterion,
    "authentication"        => CityGrid::API::AdCenter::Authentication,      
    "budget"                => CityGrid::API::AdCenter::Budget,
    "campaign"              => CityGrid::API::AdCenter::Campaign,
    "category"              => CityGrid::API::AdCenter::Category,
    "geolocation"           => CityGrid::API::AdCenter::GeoLocation,
    "mop"                   => CityGrid::API::AdCenter::MethodOfPayment,
    "image"                 => CityGrid::API::AdCenter::Image,
    "places"                => CityGrid::API::AdCenter::Places,
    "performance"           => CityGrid::API::AdCenter::Performance,
    # "reviews"             => CityGrid::API::AdCenter::Reviews
    "user"                  => CityGrid::API::AdCenter::User
  }
end