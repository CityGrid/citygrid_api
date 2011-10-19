require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "Adding a place" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::Places.search(
        :token => token,
        "placeId" => 11489139
      )
    end
  end
  
  should("not be empty") { !topic.empty? }
  should("return code OK") { topic.response.code }.equals(200)
  should("return message OK") { topic.response.message }.equals("OK")  
end