require "helper"

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
               "cardholderName"  => "Ara Tatous",
               "cardType"        => "Visa",
               "state"           => "NY" ,
               "description"     => "test addMOP",
               "firstName"       => "Ara",
               "lastName"        => "Tatous",
               "phoneNumber"     => "(818)749-3717",
               "address1"        => "3131 Montrose Ave",
               "address2"        => "Apt. 9",
               "city"            => "LaCrescenta",
               "postalCode"      => "10016",
               "accountId"       => 3440,
               "securityCode"    => "719",
               "paymentType"     => "Credit Card"
             }
           }]
         )
       end
     end
     should("not be empty"){ !topic.empty? }
     should("respond with OK"){ topic.resources.first.response.code == 200}
   end
end