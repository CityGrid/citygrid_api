require "helper"

token = AuthToken.generate

context "Mutating Ad Group" do
  setup do
    CityGrid::API::AdCenter::AdGroup.mutate(
      :token => token,
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
  should("not be empty"){ !topic.empty? }
  should("respond with OK"){ topic.adGroups.first.responseStatus.code == 200 }
end