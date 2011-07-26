class CityGrid
  module Abstraction
    class Collection < SuperArray
      include Requestable

      def self.new opts = {}
        self[].request_and_update opts
      end

      def update array
        replace array
      end
    end
  end
end