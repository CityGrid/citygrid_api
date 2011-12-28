class CityGrid
  class API
    class Content
      class Offers < Content
        define_action :where, :get, "search/where", false, true, true
        define_action :places, :get, "search/places", false, true, true
      end
    end
  end
end