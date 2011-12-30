require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

context "log in a session" do
  setup do
    CityGrid::Session.login "GARYTEST", "pppppp"
  end

  should "flag as logged in" do
    topic.logged_in?
  end
  
  should "have a valid AuthToken" do
    topic.auth_token
  end
  
  # context "run validate" do
  #   setup do
  #     topic.call_api CityGrid::API::Advertising::Authentication, 
  #       :validate
  #   end
  #   
  #   should "return correct username" do
  #     puts topic
  #   end
  # end
  
  context "mutate places" do
    setup do
      topic.call_api CityGrid::API::Advertising::Places, 
        :mutate,
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
    end
  
    should("return code 200") { topic.resources.first.response.code }.equals(200)
    should("return message OK") { topic.resources.first.response.message }.equals("OK")
  end
end