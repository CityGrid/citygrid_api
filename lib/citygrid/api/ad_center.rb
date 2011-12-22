class CityGrid
  class API
    class AdCenter < API
      server :default
      def self.initialize
        puts "init adCenter"
      end
    end
  end
end

[
  "account", "account_manager", "ad_group", "ad_group_ad", "ad_group_criterion", "ad_group_geo",
  "authentication", "budget", "campaign", "category", "geolocation", "method_of_payment", "places", "performance",
  "image", "user", "call_detail", "billing"
].each do |x|
  require "citygrid/api/ad_center/#{x}"  
end


