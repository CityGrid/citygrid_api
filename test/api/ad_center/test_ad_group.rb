require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Mutating Ad Group" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroup.search(:token => AuthToken.sales_coord, :adGroupIds => 30966312)
    end
  end
  should("not be empty"){ !topic.empty? }
  should("respond with OK"){ topic.adGroups.first.responseStatus.code == 200 }
end

context "Search Ad Group by Campaign Id" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroup.search(:token => AuthToken.sales_coord, :campaignId => 2434702)
    end
  end
  should("not be empty"){ !topic.empty? }
  should("respond with OK"){ topic.adGroups.first.responseStatus.code == 200 }
end


context "Mutating Ad Group" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroup.mutate(
        :token => AuthToken.sales_coord,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand"  => {
            "placeId"            => "10728522",
            "campaignId"         => "456",
            "contractTermMonths" =>"12",
            "monthlyServiceFee"  => "19.95",
            "budgetBids" => [{
              "actionTargetName" => "map & directions",
              "ppe"              => "1.80"
            }]
          }
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("respond with OK"){ topic.adGroups.first.responseStatus.code == 200 }
end

