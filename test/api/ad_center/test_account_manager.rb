require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))


context "Search account manager by Campaign Id" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AccountManager.search(:token => AuthToken.sales_coord, :campaignId => 16631)
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have a first name"){ !topic.firstName.nil? }
  should("have a last name"){ !topic.lastName.nil? }
end