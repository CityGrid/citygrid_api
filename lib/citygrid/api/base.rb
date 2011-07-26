require "httparty"

class CityGrid
  module API
    module Base
      class << self
        def included base
          base.instance_eval do
            include HTTParty
            extend ClassMethods
            base_uri "api.citygridmedia.com/content"
            format :json
          end
        end
      end

      module ClassMethods
        def endpoint
          # Specified for each API
        end

        def publisher
          CityGrid.publisher
        end

        def request options = {}
          query = options.merge :publisher => publisher, :format => "json"
          response = get endpoint, :query => query

          if !response["errors"] || response["errors"].empty?
            CityGrid::API::Response.new response
          else
            raise Error.new response["errors"], response
          end
        end

        private

        def convert_to_querystring hash
          hash.map do |k, v|
            key = URI.escape k.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
            val = URI.escape v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
            !value.empty? && !key.empty? ? "#{key}=#{value}" : nil
          end.compact.join("&")
        end
      end
    end

    # Throws error with message from API
    # HTTParty response is available if this class is rescued
    class Error < StandardError
      attr_reader :httparty

      def initialize errors, response = nil
        @httparty = response
        super errors.first["error"]
      end
    end
  end
end