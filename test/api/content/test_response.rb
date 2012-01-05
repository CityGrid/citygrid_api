require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "respond to reviews" do
  set :vcr, false
  r = rand(1000)
  context "try to add response" do
    setup do
      SessionHelper.sales_coord.call_api CityGrid::API::Content::Response,
        :mutate,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand" => {
            "reviewId" => 22772891,
            "text" => "comment text blue"
          }
          }]
    end
    should ("not be empty") { !topic.empty? }
    should ("already have a comment") { topic.reviews[0].responseStatus.message == "The review has already comment from the merchant." }
  end
  
  context "edit response" do
    setup do
      SessionHelper.sales_coord.call_api CityGrid::API::Content::Response,
        :mutate,
        "mutateOperationListResource" => [{
          "operator" => "SET",
          "operand" => {
            "reviewId" => 22772891,
            "text" => "comment text #{r}"
          }
          }]
    end
    should ("not be empty") { !topic.empty? }
    should ("be ok") { topic.reviews[0].responseStatus.message == "OK" }
    should ("have correct comment") { topic.reviews[0].userComments == "comment text #{r}"}
    should ("have review text") { !topic.reviews[0].review.text.empty?}
  end
  
  context "get response" do
    setup do
      SessionHelper.sales_coord.call_api CityGrid::API::Content::Response,
        :get,
        :reviewId => 22772891
    end
    should ("not be empty") { !topic.empty? }
    should ("be ok") { topic.response.code == 200 }
    should ("have correct comment") { topic.comments[0].text == "comment text #{r}"}
    should ("have review text") { !topic.review.text.empty?}
  end
end