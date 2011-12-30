class CityGrid
  class Session
    class APIAccessor
      attr_accessor :session
      
      def initialize session
        self.session = session
      end
      
      def content klass
      end
      
      def ad_center klass
      end
    end
    
    attr_accessor :username, :auth_token, :logged_in, :api
    
    def initialize
      self.logged_in = false
      self.api = {:ad_center => 1, :content => 2}
    end
    
    def logged_in?
      self.logged_in == true
    end
    
    def login username, password
      res = CityGrid::API::Accounts::Authentication.login :username => username, :password => password
      self.username = username

      case res.code
      when 201
        self.auth_token = res.authToken
        self.logged_in = true
        # puts "logged in ok"
      when 400
        # puts "error"
      else
        # puts "unexpected response code"  
      end
    end
    
    def call_api klass, action, options = {}
      klass.send action, options.merge(:token => self.auth_token)
    end
    
    class << self
      def login username, password
        session = Session.new
        session.login username, password
        
        session
      end
      
      def from_auth_token auth_token
        session = Session.new
        session.auth_token = auth_token
        session.logged_in = true
        
        session
      end
    end
  end
end