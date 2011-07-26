# Extend Hash to provide following features:
# - create by SuperHash.new(<hash>)
# - can access values by method, instead of []
# -------------------------------------------- #
class CityGrid
  module Abstraction
    class SuperHash < Hash
      def self.new attrs
        self[attrs]
      end

      def method_missing sym, *args, &block
        val = self[sym] || self[sym.to_s]

        # create new SuperHash if value is hash
        if val.is_a? Hash
          SuperHash.new val
        elsif keys.include?(sym) || keys.include?(sym.to_s)
          val
        else
          super
        end
      end
    end
  end
end