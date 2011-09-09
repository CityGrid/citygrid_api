require "helper"

token = AuthToken.generate

context "Searching categories" do
  context "by listing id" do
    setup do
      CityGrid::API::AdCenter::Category.search(
        :token         => token,
        :listingId     => 3680332,
        :startIndex    => 0,
        :numberResults => 10
      )
    end
    should("not be empty"){ !topic.empty? }
    should("respond with OK"){ topic.response.code == 200 }
    should("have resources"){ !topic.resources.empty? }
  end

  context "by query" do
    setup do
      CityGrid::API::AdCenter::Category.search(
        :keywords      => "pizza",
        :startIndex    => 0,
        :numberResults => 10,
        :token         => token
      )
    end
    should("not be empty"){ !topic.empty? }
    should("respond with OK"){ topic.response.code == 200 }
    should("have resources"){ !topic.resources.empty? }
  end
end