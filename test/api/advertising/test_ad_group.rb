require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Search Ad Group by Campaign Id" do
  setup do
    run_with_rescue do
      SessionHelper.sales_coord.call_api CityGrid::API::Advertising::AdGroup,
        :search,
        :campaignId => 2434702
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have campaignId"){ !topic.adGroups.first.campaignId.nil? }
end