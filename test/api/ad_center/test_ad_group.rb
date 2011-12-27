require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "Mutating Ad Group" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroup.search(:token => token, :adGroupIds => 30966312)
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have campaignId"){ !topic.adGroups.first.campaignId.nil? }
end

context "Search Ad Group by Campaign Id" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroup.search(:token => AuthToken.sales_coord, :campaignId => 2434702)
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have campaignId"){ !topic.adGroups.first.campaignId.nil? }
end


context "Mutating Ad Group" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroup.mutate(
        :token => token,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand"  => {
            "placeId"            => "10728522",
            "campaignId"         => "456",
            "contractTermMonths" =>"12",
            "monthlyServiceFee"  => "19.95",
            "bids" => [{
              "actionTargetName" => "map & directions",
              "ppe"              => "1.80"
            }]
          }
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have campaignId"){ !topic.adGroups.first.campaignId.nil? }
end

