require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "AdGroupCriterion" do
  context "search" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::AdGroupCriterion.search(:token => AuthToken.sales_coord, :adGroupId => 6)
      end
    end
    should("not be empty?"){ !topic.empty? }
    should("return code OK"){ topic.adGroupCriterionResources.first.response.code }.equals(200)
    should("return message OK") { topic.adGroupCriterionResources.first.response.message }.equals("OK")
  end

  context "mutate" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::AdGroupCriterion.mutate(
          :token => AuthToken.sales_coord,
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
    should("return code OK"){ topic.adGroupCriterionResources.first.response.code }.equals(200)
    should("return message OK") { topic.adGroupCriterionResources.first.response.message }.equals("OK")
  end
end