require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Searching categories" do
  context "by listing id" do
    setup do
      run_with_rescue do
        SessionHelper.kunimom.call_api CityGrid::API::Advertising::Category,
          :search,
          :listingId     => 3680332,
          :startIndex    => 0,
          :numberResults => 10
      end
    end
    should("not be empty"){ !topic.empty? }
    should("respond with OK"){ topic.response.code }.equals(200)
    should("have resources"){ !topic.categories.empty? }
  end

  context "by query" do
    setup do
      run_with_rescue do
        SessionHelper.kunimom.call_api CityGrid::API::Advertising::Category, 
          :search,
          :keywords      => "pizza",
          :startIndex    => 0,
          :numberResults => 10,
      end
    end
    should("not be empty"){ !topic.empty? }
    
    should("respond with OK"){ topic.response.code }.equals(200)
    should("have resources"){ !topic.categories.empty? }
  end
end