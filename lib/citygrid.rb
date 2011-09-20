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