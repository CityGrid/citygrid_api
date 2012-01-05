# /mutate endpoint

class CityGrid
  class API
    module Mutable
      def self.included base
        base.define_action :mutate, :post, "mutate",
          :auth_token => true,
          :format => false
      end
    end
  end
end