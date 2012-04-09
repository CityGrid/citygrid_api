class CityGrid
  class API
    class Ads < API
    end
  end
end

Dir[File.dirname(__FILE__) + '/ads/*.rb'].each {|file| require file }