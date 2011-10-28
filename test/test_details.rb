require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

c = context "Initiating a Details" do
  setup do
    begin 
      run_with_rescue do
        CityGrid::Details.new :public_id => "philip-marie-restaurant-new-york"
      end
    rescue
      puts "BLAFKASDFASDJFASDF"
    end
  end

  should "return a single Details object" do
    topic.is_a? CityGrid::Details
  end
  
  should("blow up") { false }
  
end
 
context "Initiating new MultiDetails" do
  setup do
    run_with_rescue do    
      CityGrid::MultiDetails.new :public_id => "philip-marie-restaurant-new-york"
    end
  end

  should "return a MultiDetails object" do
    topic.is_a? CityGrid::MultiDetails
  end

  should "contain multiple listings" do
    topic.reject do |listing|
      listing.is_a? CityGrid::Listing
    end.empty?
  end

  asserts "all listings are loaded" do
    topic.reject do |listing|
      listing.instance_variable_get "@loaded"
    end.empty?
  end
end