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
  "account", "ad_group", "ad_group_ad", "ad_group_criterion", "ad_group_geo",
  "authentication", "budget", "campaign", "category", "method_of_payment", "reports"
].each do |x|
  require "citygrid/api/ad_center/#{x}"  
end


