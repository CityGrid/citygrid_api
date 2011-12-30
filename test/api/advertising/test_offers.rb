require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "create an offer" do
  setup do
    SessionHelper.gary_test.call_api CityGrid::API::Advertising::Offers,
      :mutate,
      "mutateOperationListResource" => [{
        "operator" => "ADD",
        "operand" => {
          "listingIds" => "41420733",
          "offer" => { 
            "accountId" => "3440", 
            "name" => "offerTest", 
            "text" => "some texts", 
            "description" => "some description", 
            "offerStatus" => "Active", 
            "type" => "Percent_Off", 
            "redemptionType" => "Print", 
            "termsAndConditions" => "terms and conditions test", 
            "redemptionCode" => "22", 
            "redemptionURL" => "http://www.fakeurl.com", 
            "image" => "http://images.citysearch.net/assets/imgdb/image_ws/2011/10/27/0/BPYAbvWF1.jpeg", 
            "startDate" => "20111028", 
            "neverExpires" => "true"
          }
        } 
      }]
  end
  
  should("not be empty") { !topic.empty? }
  should("return code OK") { topic.resources.first.response.code }.equals(200)
  should("return message OK") { topic.resources.first.response.message }.equals("OK")  
end
