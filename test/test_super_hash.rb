require "helper"

context "A SuperHash" do
  # Test creation
  # ------------------------ #
  context "created from #new" do
    context "and given a hash" do
      setup { CityGrid::Abstraction::SuperHash.new(:test => "wassup") }
      should("return a hash") { topic.is_a? Hash }
      should("its value can be accessible through its key") { topic[:test] == "wassup"}
    end
  end

  # Test accessing of values
  # ------------------------ #
  context "that's single level" do
    context "with symbol as key" do
      setup { CityGrid::Abstraction::SuperHash.new(:test => "wassup") }
      should("can access key as method") { topic.test }
    end

    context "with string as key" do
      setup { CityGrid::Abstraction::SuperHash.new("test" => "wasssup") }
      should("can access key as method"){ topic.test }
    end
  end

  context "that has a subhash" do
    setup { CityGrid::Abstraction::SuperHash.new(:test => {:wassup => "hows it going?"}) }
    should("return another SuperHash") { topic.test.is_a? CityGrid::Abstraction::SuperHash }
    should("return correct hash") { topic.test.wassup == "hows it going?" }
  end
end