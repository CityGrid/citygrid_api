require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

context "search for an account" do
  context "by name" do
    setup do
      run_with_rescue do
        SessionHelper.sales_coord.call_api CityGrid::API::Accounts::Account,
          :search,
          :userName => '25-1'
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return message OK"){ topic.accountList.first.response.message }.equals("OK")  
    should("return response code OK"){ topic.accountList.first.response.code.to_i }.equals(200)
  end

  context "by id" do
    setup do
      run_with_rescue do
        SessionHelper.sales_coord.call_api CityGrid::API::Accounts::Account,
          :search,
          :id => 1250702
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return message OK"){ topic.accountList.first.response.message }.equals("OK")  
    should("return response code OK"){ topic.accountList.first.response.code.to_i }.equals(200)
  end
end

context "query account type" do
  context "by id" do
    setup do
      run_with_rescue do
        SessionHelper.sales_coord.call_api CityGrid::API::Accounts::Account,
          :account_type,
          :id => 1250702
      end
    end
    should("not be empty"){ !topic.empty? }
    should("return message OK"){ topic.response.message }.equals("OK")  
    should("return response code OK"){ topic.response.code.to_i }.equals(200)
    should("return type s CYB code OK"){ topic.accountType }.equals("CYB")
  end
end
 
context "import a cg account" do
  setup do
    run_with_rescue do
      SessionHelper.gary_test.call_api CityGrid::API::Accounts::Account,
        :import_to_cg,
        "mutateOperationListResource" => [{ 
          "operator" => "ADD", 
          "operand" => {
            "firstName"     => "nico-api", 
            "lastName"      => "gomez-api", 
            "phone"         => "9001111112", 
            "businessName"  =>"businessProveApi", 
            "address1"      =>"dir-api", 
            "city"          =>"montevideo", 
            "state"         =>"Montevideo", 
            "zipCode"       =>"90069" 
          } 
        }]
    end
  end
  should("not be empty"){ !topic.empty? }
  should("return message OK"){ topic.accountList.first.response.message }.equals("OK")  
  should("return response code OK"){ topic.accountList.first.response.code.to_i }.equals(200)
end

context "create an account" do
  set :vcr, false
  
  username = "randuser_9178989" # "randuser_#{rand(10000000)}"
  email = "#{username}@a.com"
  password = "randuserpass"
  
  setup do
    SessionHelper.sales_coord.call_api CityGrid::API::Accounts::Account,
      :mutate,
      "mutateOperationListResource" => [{
        "operator" => "ADD",
        "operand"  => {
          "firstName"    => "nico-api",
          "lastName"     => "gomez-api",
          "phone"        => "9001111112",
          "email"        => email,
          "userName"     => username,
          "password"     => password,
          "businessName" => "businessProveApi",
          "address1"     => "dir-api",
          "city"         => "montevideo",
          "state"        => "Montevideo",
          "zipCode"      => "90069"
        }
      }]
  end
  should("not be empty"){ !topic.empty? }
  should("return message OK"){ topic.accountList.first.response.message }.equals("OK")  
  should("return response code OK"){ topic.accountList.first.response.code.to_i }.equals(200)
  
  context "then logging in" do
    setup do
      CityGrid.login :username => username, :password => password
    end
    should("return an authToken"){ topic.authToken }
  end
  
  context "then validate with session" do
    setup do
      session = CityGrid.session username, password
      session.call_api CityGrid::API::Accounts::User, :validate, :oauth_token => session.auth_token
    end
    
    should("match on display_name") { topic.display_name }.equals(username)
    should("match on email") { topic.email }.equals(email)
  end
  
  context "then validate with raw API" do
    setup do
      session = CityGrid.session username, password
      CityGrid::API::Accounts::User.validate :oauth_token => session.auth_token
    end
    
    should("match on display_name") { topic.display_name }.equals(username)
    should("match on email") { topic.email }.equals(email)
  end
  
end


