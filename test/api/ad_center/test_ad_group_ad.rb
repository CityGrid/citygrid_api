require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "Mutating AdGroup Ads" do
  setup do
    run_with_rescue do
       CityGrid::API::AdCenter::AdGroupAd.mutate(
        :token => token,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand" => {
            "groupId" => "2861",
            "ad"=>{
              "type" =>"PERFORMANCE_AD",
              "url" => "http://www.google.com",
              "displayUrl" => "Google Display.com",
              "tagline" => "myTagline",
              "headline" =>"Headline",
              "description_1" => "Some description 1"
            }
          }
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return code OK"){ topic.adResources.first.response.code }.equals(200)
  should("return message OK") { topic.adResources.first.response.message }.equals("OK")
end