require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Logging in" do
  setup do
    run_with_rescue do
      CityGrid.login(:username => 'QASalesCoord', :password => 'pppppp')
    end
  end
  should("return an authToken"){ topic.authToken }
end
