class CityGrid
  class API
    class Advertising
      class CallDetail < Advertising
        define_action :search, :post, "get", :auth_token => true, :format => false
        define_action :note, :post, "note", :auth_token => true, :format => false
      end
    end
  end
end