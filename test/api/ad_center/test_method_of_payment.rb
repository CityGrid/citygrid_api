require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'helper'))

token = AuthToken.generate

context "Method of Payment" do
  context "search" do
    setup do
      run_with_rescue do
        CityGrid::API::AdCenter::MethodOfPayment.search(:accountId => 111, :token => token)
      end
    end
    should("not be empty"){ !topic.empty?}
    should("have MOP resources"){ !topic.mopResources.empty? }    
  end

  # API not working here
   context "mutate" do
     setup do
       run_with_rescue do
         CityGrid::API::AdCenter::MethodOfPayment.mutate(
           :token => token,
           "mutateOperationListResource" => [{
             "operator" => "ADD",
             "operand" => {
               "cardNumber"      => "4112344112344113",
               "expirationMonth" => 12,
               "expirationYear"  => 2012,
               "nameOnAccount"  => "Ara Tatous",
               "cardType"        => "Visa",
               "state"           => "NY" ,
               "description"     => "test addMOP",
               "firstName"       => "Ara",
               "lastName"        => "Tatous",
               "phoneNumber"     => "4252838811",
               "address1"        => "3131 Montrose Ave",
               "address2"        => "Apt. 9",
               "city"            => "LaCrescenta",
               "postalCode"      => "10016",
               "accountId"       => 2458392,
               "securityCode"    => "719",
               "paymentType"     => "Credit Card"
             }
           }]
         )
       end
     end
     should("not be empty"){ !topic.empty? }
     should("return code OK"){ topic.resources.first.response.code }.equals(200)
     should("return message OK") { topic.resources.first.response.message }.equals("OK")
   end
end