require "helper"

context "A Listing created from scratch" do
  setup do
    CityGrid::Listing.new "id" => 7117426
  end

  should "load details after first access" do
    topic.tips
  end
end

context "A Listing created from search" do
  setup do
    CityGrid.search(:what => "sushi", :where => "seattle").first
  end

  # Test loading
  # ----------------- #
  context "that has not been accessed" do
    should "not be loaded" do
      !topic.clone.instance_variable_get "@loaded"
    end
  end

  context "that has a method called on it for the first time" do
    setup do
      old = topic.clone
      listing = topic.clone
      listing.summary
      [old, listing]
    end

    should "become loaded" do
      topic.last.instance_variable_get "@loaded"
    end

    should "update details into itself" do
      topic.first != topic.last
    end
  end

  # Test offers, reviews
  # -------------------- #
  should "get offers" do
    !topic.offers.empty?
  end

  # Test reviews
  # -------------------- #
  should "get reviews" do
    !topic.reviews.empty?
  end

  context "updating reviews" do
    setup do
      [topic.reviews.clone, topic.reviews(:rpp => 2).clone]
    end

    should "not be the same" do
      topic[0] != topic[-1]
    end
  end
end