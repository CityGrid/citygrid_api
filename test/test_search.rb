require "helper"

context "searching for a CityGrid listing" do
  setup do
    CityGrid.search :what => "sushi", :where => "Seattle"
  end

  should "create an array" do
    topic.is_a? Array
  end

  should_not "be empty" do
    topic.empty?
  end

  should "create an array containing Listing objects" do
    topic.reject do |listing|
      listing.is_a? CityGrid::Listing
    end.empty?
  end
end