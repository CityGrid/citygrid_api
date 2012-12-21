# /get endpoint

class CityGrid
  class API
    module Searchable
      def self.included base
        base.define_action :search, :get, "get",
          :auth_token => true,
          :format => true

        base.define_action :get, :get, nil,
          :auth_token => true,
          :format => true
      end
    end
  end
end