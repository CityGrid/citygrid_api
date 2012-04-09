require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

context "Login with bad password" do
	setup do
		begin
			CityGrid.login :username => "iamafakeuserandineverexisted", :password => 'sofakethatsmyname'
		rescue => ex
			return ex
		end
	end

	should("return an AccountNotFoundError"){ topic.instance_of? CityGridExceptions::AccountNotFoundError }
end

context "Login with no username" do
	setup do
		begin
			CityGrid.login :username => "", :password => 'sofakethatsmyname'
		rescue => ex
			return ex
		end
	end

	should("return an UsernameRequiredError"){ topic.instance_of? CityGridExceptions::UsernameRequiredError }	
end