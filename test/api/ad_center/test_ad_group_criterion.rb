require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "AdGroupCriterion" do
  context "search" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::AdGroupCriterion.search(:token => token, :adGroupId => 6)
      end
    end
    should("not be empty?"){ !topic.empty? }
    should("respond with OK"){ topic.adGroupCriterionResources.first.response.code == 200 }
  end

  context "mutate" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::AdGroupCriterion.mutate(
          :token => token,
          "mutateOperationListResource" => [{
            "operator" => "ADD",
            "operand" => {
              "adGroupId" => "2",
              "adGroupAdId" => "1",
              "adGroupCriterionId" =>
              "1722",
              "type" => "2"
            }
          }, {
            "operator" => "REMOVE",
            "operand" => {
              "adGroupId" => "2",
              "adGroupAdId" => "1",
              "adGroupCriterionId" => "1722",
              "type" => "2"
            }
          }]
        )
      end
    end
    should("not be empty"){ !topic.empty? }
    should("respond with OK"){ topic.adGroupCriterionResources.first.response.code == 200}
  end
end