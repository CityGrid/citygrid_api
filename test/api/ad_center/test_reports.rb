require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "Report summary" do
  context "daily" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::Reports.summary(
          :daily,
          :campaignId => 786,
          :period     => 'last30Days',
          :token      => token
        )
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
        CityGrid::API::AdCenter::Reports.summary(
          :actions,
          :campaignId => 786,
          :period     => 'last30Days',
          :token      => token
        )
      end
    end
    should("not be empty"){ !topic.empty? }
    should("have user actions"){ topic.userActions.length > 0 }
  end
end