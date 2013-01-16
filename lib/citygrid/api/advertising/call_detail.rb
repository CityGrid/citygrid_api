class CityGrid
  class API
    class Advertising
      class CallDetail < Advertising
        define_action :search, :post, "", :auth_token => true, :format => false
      end
    end
  end
end