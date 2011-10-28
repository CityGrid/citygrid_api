require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "Adding a campaign" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::Campaign.mutate(
        :token => token,
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
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return code OK"){ topic.campaignResources.first.response.code }.equals(200)
  should("return message OK") { topic.campaignResources.first.response.message }.equals("OK")
end