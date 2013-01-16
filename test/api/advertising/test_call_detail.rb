require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "search for call detail" do
  set :vcr, false
  # context "by campaign" do
  #   setup do
  #     SessionHelper.sales_coord.call_api CityGrid::API::Advertising::CallDetail,
  #       :search,
  #       :campaignId => 786,
  #       :period     => 'last30Days'
  #   end
  #   should("not be empty"){ !topic.empty? }
  #   should("have call detail resources"){
  #     topic.callDetailsResources.length > 0
  #   }
  # end
  # 
  # context "by adgroup" do
  #   setup do
  #     SessionHelper.sales_coord.call_api CityGrid::API::Advertising::CallDetail,
  #       :search,
  #       :adGroupId  => 7264632,
  #       :period     => 'last30Days'
  #   end
  #   should("not be empty"){ !topic.empty? }
  #   should("have call detail resources"){
  #     topic.callDetailsResources.length > 0
  #   }
  # end
  
  setup do
    puts CityGrid::API::Advertising::CallDetail.search :token => '256aa52875b142019b284ba2614f0428', :adGroupId => 20215642, :period => 'last30Days'
  end

  # Can't really do this test if can't reliably access the same note again and again
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