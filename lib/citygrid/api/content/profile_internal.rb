class CityGrid
  class API
    class Content
      class ProfileInternal < Content
        define_action :content, :get, "content", :auth_token => false
      end
    end
  end
end