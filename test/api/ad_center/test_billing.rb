require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))


context "Search Billing by Campaign Id" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::Billing.search(:token => AuthToken.sales_coord, :campaignId => 16631)
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have campaignId"){ !topic.campaignId.nil? }
end


