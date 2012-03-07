class CityGrid
  class API
    class Accounts
      class TempImpersonation < Accounts
      	define_action :impersonate, :get, "impersonate", :auth_token => true, :format => false
      end
    end
  end
end