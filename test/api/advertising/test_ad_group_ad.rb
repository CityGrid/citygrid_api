require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Mutating AdGroup Ads" do
  setup do
    run_with_rescue do
      SessionHelper.sales_coord.call_api CityGrid::API::Advertising::AdGroupAd,
        :mutate,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand" => {
            "groupId" => "2861",
            "ad"=>{
              "type" =>"PERFORMANCE_AD",
              "tagline" => "myTagline",
              "imageUrl" => "http://some_url.com"
            }
          }
        }]
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return code OK"){ topic.adGroupAds.first.response.code }.equals(200)
  should("return message OK") { topic.adGroupAds.first.response.message }.equals("OK")
end