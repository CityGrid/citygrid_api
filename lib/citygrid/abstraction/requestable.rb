class CityGrid
  module Abstraction
    module Requestable
      def self.included base
        base.instance_eval do
          attr_reader :raw
        end
      end

      def api
        # set corresponding API here
      end

      def request opts = {}
        api.request opts
      end

      # Run request, preprocess, and update.
      # Write an update method if it doesn't already exist
      #
      # def update
      #
      # end
      
      def request_and_update opts = {}
        @raw = request opts
        update preprocess(@raw)
      end

      private

      # Preprocess request.
      # Overwrite this method to preprocess request before updating.
      def preprocess response
        response
      end
    end
  end
end