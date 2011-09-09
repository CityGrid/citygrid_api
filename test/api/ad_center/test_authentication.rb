require "helper"

context "Logging in" do
  setup{ CityGrid.login(:username => 'QASalesCoord', :password => 'pppppp') }
  should("return an authToken"){ topic.authToken }
end
