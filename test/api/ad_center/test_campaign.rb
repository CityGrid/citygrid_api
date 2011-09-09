require "helper"

token = AuthToken.generate

context "Adding a campaign" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::Campaign.mutate(
        :token => token,
        :mutateOperationListResource => [{
          :operator => "ADD",
          :operand  => {
            :accountId => "123",
            :name      => "PleaseWork6",
            :startDate => "20110625",
            :endDate   => "20111011",
            :product   => "PERFORMANCE",
            :budget    => {:amount => 30000},
            :mopId     => 2961
          }
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have campaign resources"){ topic.campaignResources.first.response.code == 200 }
end