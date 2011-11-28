require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "Search for a user" do
  context "by name" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::Account.search(
          :token    => AuthToken.sales_coord,
          :userName => '25-1'
        )
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return message OK"){ topic.accountResources.first.response.message }.equals("OK")  
    should("return response code OK"){ topic.accountResources.first.response.code.to_i }.equals(200)
  end

  context "Search by id" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::Account.search(
          :token => AuthToken.sales_coord,
          :id    => 1250702
        )
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return message OK"){ topic.accountResources.first.response.message }.equals("OK")  
    should("return response code OK"){ topic.accountResources.first.response.code.to_i }.equals(200)
  end
end

context "Import a cg account" do
  setup do
    run_with_rescue do
      auth_token = CityGrid.login(
        :username => 'GARYTEST',
        :password => 'pppppp'
      ).authToken
      
      CityGrid::API::AdCenter::Account.import_to_cg(
        :token => auth_token,
        "mutateOperationListResource" => [{ 
          "operator" => "ADD", 
          "operand" => {
            "firstName" => "nico-api", 
            "lastName" => "gomez-api", 
            "phone" => "9001111112", 
            "businessName" =>"businessProveApi", 
            "address1" =>"dir-api", 
            "city" =>"montevideo", 
            "state" =>"Montevideo", 
            "zipCode" =>"90069" 
          } 
        }]
      )
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return message OK"){ topic.accountResources.first.response.message }.equals("OK")  
  should("return response code OK"){ topic.accountResources.first.response.code.to_i }.equals(200)
end


context "Creating an account" do
  setup do
    run_with_rescue do
      CityGrid::API::AdCenter::Account.mutate(
        :token => AuthToken.sales_coord,
        "mutateOperationListResource" => [{
          "operator" => "ADD",
          "operand"  => {
            "firstName"    => "nico-api",
            "lastName"     => "gomez-api",
            "phone"        => "9001111112",
            "email"        => "goodtry#{AuthToken.rand_number}@a.com",
            "userName"     => "goodtry#{AuthToken.rand_number}",
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
  should("return message OK"){ topic.accountResources.first.response.message }.equals("OK")  
  should("return response code OK"){ topic.accountResources.first.response.code.to_i }.equals(200)
end

context "Logging in" do
  setup do
    run_with_rescue do
      CityGrid.login(:username => "goodtry#{AuthToken.rand_number}", :password => 'pppppp')
    end
  end
  should("return an authToken"){ topic.authToken }
end
