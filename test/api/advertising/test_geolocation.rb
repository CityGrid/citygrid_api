require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Geo" do
  setup do
    run_with_rescue do
      CityGrid::API::Advertising::GeoLocation.search(
      "streetAddress" => "720 3rd ave",
      "city" => "seattle",
      "state" => "wa",
      "zipCode" => "98007", 
      :token  => ""
      )
    end
  end
  
  should("not be empty") { !topic.empty? }
  should("return message OK") { topic.message }.equals("OK")
  should("return code 200") { !topic.geocodeResponse.first.geoAccuracy.nil? }  
end
