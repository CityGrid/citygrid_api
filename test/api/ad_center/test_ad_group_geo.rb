require "helper"

token = AuthToken.generate

context "Searching AdGroup Geo" do
  setup do
    CityGrid::API::AdCenter::AdGroupGeo.search(
      :token          => token,
      "streetAddress" => "200Robertson Blvd",
      "city"          => "Beverly Hills",
      "state"         => "CA",
      "zipCode"       => "90211"
    )
  end
  should("not be empty"){ !topic.empty? }
  should("have geocode responses"){ !topic.geocodeResponse.empty? }
end