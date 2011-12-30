require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Call Detail" do
  context "by campaign" do
    setup do
      SessionHelper.sales_coord.call_api CityGrid::API::Advertising::CallDetail,
        :campaign,
        :campaignId => 786,
        :period     => 'last30Days'
    end
    should("not be empty"){ !topic.empty? }
    should("have call detail resources"){
      topic.callDetailsResources.length > 0
    }
  end

  # context "note" do
  #   setup do
  #     run_with_rescue do
  #       CityGrid::API::Advertising::CallDetail.note(
  #         :campaignId => 786,
  #         :period     => 'last30Days',
  #         :token      => token
  #       )
  #     end
  #   end
  #   should("not be empty"){ !topic.empty? }
  #   should("have user actions"){ topic.userActions.length > 0 }
  # end
end