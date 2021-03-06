class StoredReporter < Riot::SilentReporter
  class ContextResult
    attr_accessor :desc, :children, :passes, :fails, :requests
    
    def initialize context
      @fails = []
      @passes = []
      @requests = []
      @children = []
      
      @desc = context.description
    end
    
    def fail fail
      @fails << fail
    end
    
    def pass pass
      @passes << pass
    end
    
    def passed?
      return false unless fails.empty?
      
      children.each do |c|
        return false unless c.passed?
      end
      
      return true
    end
    
  end
  
  class Fail
    attr_accessor :desc, :result, :a, :b

    def initialize desc, result, a = nil, b = nil
      self.desc = desc
      self.result = result
    end
  end

  class Pass
    attr_accessor :desc, :result

    def initialize desc, result
      self.desc = desc
      self.result = result
    end
  end
  
  attr_accessor :context_results
  
  def initialize string_io
    @string_io = string_io
    
    # lookup hash for contexts to handle nesting
    @contexts = {}
    @context_results = []
    super()
  end
  
  def context_finished
    return unless @current_result
    
    @current_result.requests = RequestTrap.trap.clone
    RequestTrap.trap.clear
    # 
    # str = @string_io.string
    # # puts "flushing with #{str} inside #{@current_result.desc}"
    # # @current_result.curls = str.split(/\n/).select{|x| x.index("curl") == 0} if @current_result
    # @string_io.truncate 0
  end
  
  def describe_context context
    context_finished
    @current_result = ContextResult.new context    
    @contexts[context] = @current_result
    
    if context.parent && @contexts[context.parent]
      @contexts[context.parent].children << @current_result
    else
      # it's a top level result
      @context_results << @current_result
    end
    
    super context
  end
      
  def pass *args
    @current_result.pass Pass.new *args
  end
  
  def error *args
    @current_result.fail Fail.new *args
  end
  
  def fail *args
    @current_result.fail Fail.new *args
  end
end