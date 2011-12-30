require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Search Billing by Campaign Id" do
  setup do
    run_with_rescue do
      SessionHelper.sales_coord.call_api CityGrid::API::Advertising::Billing,
        :search, 
        :campaignId => 16631
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have campaignId"){ !topic.billing.campaignId.nil? }
end


