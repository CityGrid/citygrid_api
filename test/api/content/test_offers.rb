require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

# context "Getting an offer" do
#   setup do
#     run_with_rescue do
#       response = CityGrid::API::Content::Offers.where(
#         :what => "restaurant",
#         :where => "98033",
#         :format => :json
#       )
#       response
#     end
#   end
#   
#   should("not be empty") { !topic.empty? } 
# end

context "Getting an offer by listing ID" do
  setup do
    run_with_rescue do
      CityGrid::API::Content::Offers.places(
        :listing_id => 628554020
      )
    end
  end
  
  should("not be empty") { !topic.empty? } 
end