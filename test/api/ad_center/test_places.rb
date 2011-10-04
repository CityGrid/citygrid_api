require "helper"

token = AuthToken.generate

context "Adding a place" do
  setup do
    run_with_rescue do
      CityGrid::API::Content::Places.mutate(
        :token => token,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand" => {
            "name" => "Pi on sunset in LAAAAAAAAAAAAAA",
            "address_1" => "Jackson 2102",
            "address_2" => "",
            "city" => "Los Angeles",
            "state" => "California",
            "postal_code" => 90025,
            "phone_number" => 3103333333,
            "website_url" => "pi.com",
            "primary_tag_id" => "3623",
            "bullet1" => "Knoll bullet 1",
            "tagline" => "my tagline",
            "primary_tag_id" => 3623,
            "secondary_tags" => '1776'}
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return response OK"){ topic.resources.first.response.code == 200 }
end

context "Update a place" do
  setup do
    run_with_rescue do
      CityGrid::API::Content::Places.mutate(
        :token => token,
        "mutateOperationListResource" => [{
          "operator" => "SET",
          "operand" => {
            "name" => "Pi on sunset in LAAAAAAAAAAAAAA",
            "address_1" => "Jackson 2102",
            "address_2" => "",
            "city" => "Los Angeles",
            "state" => "California",
            "postal_code" => 90025,
            "phone_number" => 3103333333,
            "website_url" => "pi.com",
            "primary_tag_id" => "3623",
            "bullet1" => "Knoll bullet 1",
            "tagline" => "my tagline",
            "primary_tag_id" => 3623,
            "secondary_tags" => '1776',
            "listing_id" => '755498442'}
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return response OK"){ topic.resources.first.response.code == 200 }
end