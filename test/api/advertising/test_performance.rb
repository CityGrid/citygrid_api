require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Report summary" do
  context "daily" do
    setup do
      run_with_rescue do
        SessionHelper.sales_coord.call_api CityGrid::API::Advertising::Performance,
          :daily,
          :campaignId => 786,
          :period     => 'last30Days'
      end
    end
    
    should("not be empty"){ !topic.empty? }
    should("have performance resources"){
      topic.dailyCampaignPerformanceResources.length > 0
    }
  end

  context "user actions" do
    setup do
      run_with_rescue do
        SessionHelper.sales_coord.call_api CityGrid::API::Advertising::Performance,
          :actions,
          :campaignId => 786,
          :period     => 'last30Days'
      end
    end
    
    should("not be empty"){ !topic.empty? }
    should("have user actions"){ topic.userActions.length > 0 }
  end
end