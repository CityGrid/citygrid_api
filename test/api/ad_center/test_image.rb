require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "Upload an image" do
  context "Add a preview" do
    setup do
      run_with_rescue do
        image_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_img.png'))
        CityGrid::API::AdCenter::Image.preview(
          :token => token,
          "mutateOperationListResource" => [{ 
            "operator" => "ADD", 
            "image" => "the image",
            "image_type" => "Ad",
            "userId" => 1250702,
            "operand" => "blah"#File.open(image_path).read.to_s
          }]
        )
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return message OK"){ topic.accountResources.first.response.message }.equals("OK")  
    should("return response code OK"){ topic.accountResources.first.response.code.to_i }.equals(200)
  end
end