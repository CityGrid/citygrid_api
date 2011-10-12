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
            # :accountId => "123",
            :name      => "PleaseWork6",
            :startDate => Date.today.to_s.gsub("-", ""),
            :endDate   => (Date.today + 10).to_s.gsub("-", ""),
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