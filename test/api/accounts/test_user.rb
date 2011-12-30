require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "user log in with raw API" do
  setup do
    CityGrid.login :username => "GARYTEST", :password => 'pppppp'
  end
  should("return an authToken"){ topic.authToken }
end

context "user log in with session" do
  setup do
    CityGrid.session "GARYTEST", "pppppp"
  end
  should("have an auth_token"){ topic.auth_token }
  should("be logged in"){ topic.logged_in? }
end