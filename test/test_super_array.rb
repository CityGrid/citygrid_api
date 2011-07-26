require "helper"

super_array = CityGrid::Abstraction::SuperArray
super_hash  = CityGrid::Abstraction::SuperHash

context "A SuperArray" do
  context "created" do
    context "with a single level" do
      setup { super_array.new([1, 2, 3]) }
      should("return the contents"){ topic == [1, 2, 3]}
    end

    context "with a hash inside" do
      setup { super_array.new([1, {:hello => "there"}])}
      should("replace it with a SuperHash"){ topic[1].is_a? super_hash}
    end

    context "with an array inside" do
      setup { super_array.new([1, [2, 3, 4]])}
      should("replace it with a SuperArray"){ topic[1].is_a? super_array}
    end
  end
end