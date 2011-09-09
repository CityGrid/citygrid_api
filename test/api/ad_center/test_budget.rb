require "helper"

token = AuthToken.generate

context "Searching budgets" do
  setup{ CityGrid::API::AdCenter::Budget.search(:listingId => 833372, :token => token) }
  should("not be empty"){ !topic.empty? }
  should("have budget suggestions"){ topic.budgetSuggestionResources.length > 0 }
end