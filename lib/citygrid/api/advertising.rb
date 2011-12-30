class CityGrid
  class API
    class Advertising < API
    end
  end
end

CityGrid::API::AdCenter = CityGrid::API::Advertising # backwards compat

Dir[File.dirname(__FILE__) + '/advertising/*.rb'].each {|file| require file }