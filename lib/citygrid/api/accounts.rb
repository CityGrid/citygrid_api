class CityGrid
  class API
    class Accounts < API
    end
  end
end

Dir[File.dirname(__FILE__) + '/accounts/*.rb'].each {|file| require file }