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
          unless klass       
            puts "Unknown API #{api}" 
            next
          end
          
          klass.endpoint endpoint
          puts "#{CLASS_MAPPING[api]} => #{endpoint}"
        end
      end
    end
    
    def set_env config_file
      File.open config_file, "r" do |file|
        while line = file.gets
          api, host = line.split("=").map{|x| x.chomp}
          host = "http://#{host}" unless host.start_with?("http")
          klass = CLASS_MAPPING[api]
          unless klass
            puts "Unknown API #{api}"
            next
          end
          
          klass.base_uri host
          puts "#{CLASS_MAPPING[api]} => #{host}"
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

class CityGrid
  CLASS_MAPPING = {
    "account"               => CityGrid::API::AdCenter::Account,
    "adgroup"               => CityGrid::API::AdCenter::AdGroup,
    "adgroupad"             => CityGrid::API::AdCenter::AdGroupAd,
    "adgroupgeo"            => CityGrid::API::AdCenter::AdGroupGeo,
    "adgroupcriterion"      => CityGrid::API::AdCenter::AdGroupCriterion,
    "authentication"        => CityGrid::API::AdCenter::Authentication,      
    "budget-suggestion"     => CityGrid::API::AdCenter::Budget,
    "campaign"              => CityGrid::API::AdCenter::Campaign,
    "category"              => CityGrid::API::AdCenter::Category,
    # "geolocation"         => CityGrid::API::AdCenter::GeoLocation,
    "mop"                   => CityGrid::API::AdCenter::MethodOfPayment,
    # "image"               => CityGrid::API::AdCenter::Image,
    "report"                => CityGrid::API::AdCenter::Reports,
    # "reviews"               => CityGrid::API::AdCenter::Reviews
    # "user"                => CityGrid::API::AdCenter::User
  }
end