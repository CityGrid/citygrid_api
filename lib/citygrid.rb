# Ruby 1.9.2 has YAML::ENGINE and will blow up if you don't define yamler
# Ruby 1.8.7 doesn't have YAML::ENGINE, this should take care of both cases
YAML::ENGINE.yamler= 'syck' if defined?(YAML::ENGINE)

class CityGrid
  class << self
    def publisher= code
      @publisher = code
    end

    def load_config file_path, env = nil
      config = YAML.load_file(file_path)
      @config = env ? config[env] : config.first[1]
      [:default, :ssl].each do |x|
        @config[x] = HTTParty.normalize_base_uri(@config[x.to_s]) if @config[x.to_s]
      end
      
      @config
    end
    
    def config
      raise EndpointsNotConfigured unless @config && !@config.nil?
      @config
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
    "adgroup"               => CityGrid::API::AdCenter::AdGroup,
    "adgroupad"             => CityGrid::API::AdCenter::AdGroupAd,
    "adgroupgeo"            => CityGrid::API::AdCenter::AdGroupGeo,
    "adgroupcriterion"      => CityGrid::API::AdCenter::AdGroupCriterion,
    "authentication"        => CityGrid::API::AdCenter::Authentication,      
    "budget"                => CityGrid::API::AdCenter::Budget,
    "campaign"              => CityGrid::API::AdCenter::Campaign,
    "category"              => CityGrid::API::AdCenter::Category,
    "geolocation"           => CityGrid::API::AdCenter::GeoLocation,
    "mop"                   => CityGrid::API::AdCenter::MethodOfPayment,
    "image"                 => CityGrid::API::AdCenter::Image,
    "places"                => CityGrid::API::Content::Places,
    "performance"           => CityGrid::API::AdCenter::Reports,
    # "reviews"             => CityGrid::API::AdCenter::Reviews
    "user"                  => CityGrid::API::AdCenter::User
  }
end