require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Upload an image" do
  context "Add a preview" do
    setup do
      run_with_rescue do
        image_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test_img.jpg'))
        resp = CityGrid::API::AdCenter::Image.upload(68, "a pic", "PROFILE_IMAGE", image_path, :token => AuthToken.sales_coord)
        ap resp
        resp
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return message OK"){ topic.resources.first.response.message }.equals("OK")  
    should("return response code OK"){ topic.resources.first.response.code.to_i }.equals(200)
  end
end