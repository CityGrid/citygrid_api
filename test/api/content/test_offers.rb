require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))


context "Getting an offer" do
  setup do
    run_with_rescue do
      response = CityGrid::API::Content::Offers.where(
        :what => "restaurant",
        :where => "98005"
      )
      response
    end
  end
  
  should("not be empty") { !topic.empty? } 
end

