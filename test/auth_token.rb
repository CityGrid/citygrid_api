class AuthToken
  class << self
    def kunimom
      @@kunimom ||= CityGrid.login(
        :username => 'kunimom',
        :password => 'pppppp'
      ).authToken
    end
    
    def dou
      @@dou ||= CityGrid.login(
        :username => 'doushen2',
        :password => 'abcd1234'
      ).authToken
    end
    
    def sales_coord
      @@sales_cord ||= CityGrid.login(
        :username => 'QASalesCoord',
        :password => 'pppppp'
      ).authToken
    end
    
    def gary_test
      @@gary_test ||= CityGrid.login(
        :username => 'GARYTEST',
        :password => 'pppppp'
      ).authToken
    end
    
    def rand_number
      @@rand_number ||= rand(10000000)
    end
    
    def generate
      kunimom
    end
  end
end