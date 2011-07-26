# Extend Array to provide following features:
# - creates SuperHash for hashes
# - creates SuperArray for arrays
# ------------------------------- #
class CityGrid
  module Abstraction
    class SuperArray < Array
      def self.new objs
        array = self.[] *objs
        array.map! do |obj|
          if obj.class == Hash
            SuperHash.new obj
          elsif obj.class == Array
            new obj
          else
            obj
          end
        end
      end
    end
  end
end