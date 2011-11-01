require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Logging in" do
  setup do
    run_with_rescue do
      CityGrid.login(:username => 'QASalesCoord', :password => 'pppppp')
    end
  end
  should("return an authToken"){ topic.authToken }
end

context "Valiate user" do
  setup do
    run_with_rescue do
      token = AuthToken.kunimom
      CityGrid::API::AdCenter::Authentication.validate :oauth_token => token
    end
  end
  should("have id"){ topic.id }
  should("have status"){ topic.status }
  should("have display_name"){ topic.display_name }
end
