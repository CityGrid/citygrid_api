require 'spec_helper'

describe "listing apis" do
  
  context "search" do
  
    it "should not raise an error" do
      lambda do
        CityGrid.search :what => "sushi", :where => "Seattle"
      end.should_not raise_error
    end
  
    it "should get a response" do
      data = CityGrid.search :what => "sushi", :where => "Seattle"
      data.should_not be_empty
      data.first.should_not be_empty
    end
    
  end
  
  context "details" do
    # CityGrid::Details.new :public_id =>
    
    it "should not raise an error" do
      lambda do
        CityGrid::Details.new :public_id => "philip-marie-restaurant-new-york"
      end.should_not raise_error
    end
  
    it "should get a response" do
      data = CityGrid::Details.new :public_id => "philip-marie-restaurant-new-york"
      data.should_not be_empty
    end
  end
  
end