require "citygrid/abstraction"
require "citygrid/api"

require "citygrid/search"
require "citygrid/reviews"
require "citygrid/offers"
require "citygrid/details"
require "citygrid/listing"

class CityGrid
  class << self
    def publisher= code
      @@publisher = code
    end

    def publisher
      raise PublisherNotConfigured if !defined?(@@publisher) || @@publisher.nil?
      @@publisher
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
  end

  # Errors
  # --------------- #
  class PublisherNotConfigured < StandardError
    def initialize
      super "Publisher hasn't been configured. Run 'CityGrid.publisher=<code>'"
    end
  end
end