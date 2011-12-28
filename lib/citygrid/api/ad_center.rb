class CityGrid
  class API
    class AdCenter < API
    end
  end
end

Dir[File.dirname(__FILE__) + '/ad_center/*.rb'].each {|file| require file }