require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "impersonate user" do
	setup do
		SessionHelper.gary_test.call_api CityGrid::API::Accounts::TempImpersonation, :impersonate, :customerId => 125902
	end
	should("have a different auth token"){pp topic.authToken}
end