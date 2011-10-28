require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Searching AdGroup Geo" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::AdGroupGeo.search(
        :token          => AuthToken.sales_coord,
        "adGroupId"     => 78,
        "streetAddress" => "200 Robertson Blvd",
        "city"          => "Beverly Hills",
        "state"         => "CA",
        "zipCode"       => "90211"
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have entries"){ topic.totalNumEntries > 0}
  should("have adGroupGeos"){ !topic.adGroupGeos.empty? }
end