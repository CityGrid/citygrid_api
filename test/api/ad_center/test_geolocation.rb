require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Geo" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::GeoLocation.search(
      "streetAddress" => "720 3rd ave",
      "city" => "seattle",
      "state" => "wa",
      "zipCode" => "98007", 
      :token  => ""
      )
    end
  end
  
  should("not be empty") { !topic.empty? }
  should("return code OK") { topic.response.code }.equals(200)
  should("return message OK") { topic.response.message }.equals("OK")  
end
