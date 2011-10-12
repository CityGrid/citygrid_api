require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

context "loading config file" do
  setup do
    # CityGrid.load_config "../citygrid_api.yml"
  end

  should "load correctly" do
    # ap CityGrid.config
    # puts "adgroup base: "
    # ap CityGrid::API::AdCenter::AdGroup.base_uri
    # ap CityGrid::API::AdCenter::AdGroup.endpoint
  end
end