require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "getting reviews" do
  context "by listing_id" do
    setup do
      CityGrid::API::Content::Reviews.where :listing_id => 628554020
    end
  
    should("not be empty") { !topic.empty? } 
  end
end