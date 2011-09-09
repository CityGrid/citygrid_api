require "helper"

token = AuthToken.generate

context "Getting account info" do
  context "by name" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::Account.search(
          :token    => token,
          :userName => 'QASalesCoord'
        )
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return response code OK"){ topic.accountResources.first.response.code.to_i == 200}
  end

  context "by id" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::Account.search(
          :token => token,
          :id    => 1250702
        )
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return response code OK"){ topic.accountResources.first.response.code.to_i == 200}
  end
end

context "Creating an account" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::Account.mutate(
        :token => token,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand"  => {
            "firstName"    => "nico-api",
            "lastName"     => "gomez-api",
            "phone"        => "9001111112",
            "email"        => "goodtry#{rand(10000000)}@a.com",
            "userName"     => "goodtry#{rand(10000000)}",
            "password"     => "pppppp",
            "businessName" => "businessProveApi",
            "address1"     => "dir-api",
            "city"         => "montevideo",
            "state"        => "Montevideo",
            "zipCode"      => "90069"
          }
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return response code OK"){ topic.accountResources.first.response.code.to_i == 200 }
end
