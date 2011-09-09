require "helper"

token = AuthToken.generate

context "Report summary" do
  context "daily" do
    setup do
      CityGrid::API::AdCenter::Reports.summary(
        :daily,
        :campaignId => 786,
        :period     => 'last30Days',
        :token      => token
      )
    end
    should("not be empty"){ !topic.empty? }
    should("have performance resources"){
      topic.dailyCampaignPerformanceResources.length > 0
    }
  end

  context "user actions" do
    setup do
      CityGrid::API::AdCenter::Reports.summary(
        :actions,
        :campaignId => 786,
        :period     => 'last30Days',
        :token      => token
      )
    end
    should("not be empty"){ !topic.empty? }
    should("have user actions"){ topic.userActions.length > 0 }
  end
end