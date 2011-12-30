require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Searching budgets" do
  setup do
    run_with_rescue do
      SessionHelper.kunimom.call_api CityGrid::API::Advertising::Budget,
        :search,
        :listingId => 833372
    end
  end
  should("not be empty"){ !topic.empty? }
  should("have budget suggestions"){ topic.budgetSuggestionResources.length > 0 }
end