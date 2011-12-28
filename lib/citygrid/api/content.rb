class CityGrid
  class API
    class Content < API
    end
  end
end

Dir[File.dirname(__FILE__) + '/content/*.rb'].each {|file| require file }