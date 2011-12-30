# cache sessions
class SessionHelper
  class << self
    def kunimom
      @@kunimom ||= CityGrid.session 'kunimom', 'pppppp'
    end
    
    def dou
      @@dou ||= CityGrid.session 'doushen2', 'abcd1234'
    end
    
    def sales_coord
      @@sales_cord ||= CityGrid.session 'QASalesCoord', 'pppppp'
    end
    
    def gary_test
      @@gary_test ||= CityGrid.session 'GARYTEST', 'pppppp'
    end
  end
end