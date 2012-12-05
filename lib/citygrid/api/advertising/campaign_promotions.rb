class CityGrid
  class API
    class Advertising
      class CampaignPromotions < Advertising
        include CityGrid::API::Mutable
      end
    end
  end
end