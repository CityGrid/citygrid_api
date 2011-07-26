class CityGrid
  module Abstraction
    class Item < SuperHash
      include Requestable

      def self.new opts = {}
        self[{}].request_and_update opts
      end
    end
  end
end