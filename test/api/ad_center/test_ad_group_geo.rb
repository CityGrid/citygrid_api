require "helper"

token = AuthToken.generate

context "Searching AdGroup Geo" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroupGeo.search(
        :token          => token,
        "streetAddress" => "200Robertson Blvd",
        "city"          => "Beverly Hills",
        "state"         => "CA",
        "zipCode"       => "90211"
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have geocode responses"){ !topic.geocodeResponse.empty? }
end