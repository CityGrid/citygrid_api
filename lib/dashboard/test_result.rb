class TestResult
  attr_accessor :desc, :results
  
  def initialize desc
    self.desc = desc
    @results = []
  end
end