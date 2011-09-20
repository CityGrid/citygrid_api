class CityGrid
  class API
    class Content < API
    end
  end
end

[
  "offers", "places", "reviews"
].each do |x|
  require "citygrid/api/content/#{x}"  
end
