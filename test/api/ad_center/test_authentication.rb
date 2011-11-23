require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

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
