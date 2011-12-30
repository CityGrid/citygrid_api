require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "create campaign" do
  setup do    
    SessionHelper.kunimom.call_api CityGrid::API::Advertising::Campaign,
      :mutate,
      :mutateOperationListResource => [{
        :operator => "ADD",
        :operand  => {
          :name      => "PleaseWork6",
          :startDate => (Date.today+1).to_s.gsub("-", ""),
          :endDate   => (Date.today + 10).to_s.gsub("-", ""),
          :product   => "PERFORMANCE",
          :budget    => {:amount => 30000},
          :mopId     => 386742
        }
      }]
  end
  
  should("not be empty"){ !topic.empty? }
  should("return code OK"){ topic.campaigns.first.response.code }.equals(200)
  should("return message OK") { topic.campaigns.first.response.message }.equals("OK")
  
  context "then create ad_group belonging to campaign" do
    setup do
      SessionHelper.kunimom.call_api CityGrid::API::Advertising::AdGroup,
        :mutate,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand"  => {
            "placeId"            => "10728522",
            "campaignId"         => topic.campaigns.first.id,
            "contractTermMonths" =>"12",
            "monthlyServiceFee"  => "19.95",
            "bids" => [{
              "actionTargetName" => "map & directions",
              "ppe"              => "1.80"
            }]
          }
        }]
    end
    should("not be empty"){ !topic.empty? }
    should("have campaignId"){ !topic.adGroups.first.campaignId.nil? }

    context "then search for ad_group belonging to the user" do
      setup do
        SessionHelper.kunimom.call_api CityGrid::API::Advertising::AdGroup,
          :search,
          :adGroupIds => topic.adGroups.first.id
      end
      should("not be empty"){ !topic.empty? }
      should("have campaignId"){ !topic.adGroups.first.campaignId.nil? }
    end
  end
  
end