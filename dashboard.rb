require 'rubygems'
require 'sinatra'
require "awesome_print"
require "riot"
require "haml"
require 'stringio'

IN_DASHBOARD = true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib', "dashboard"))  
require "stored_reporter"
require "sinatra_partial"

helpers Sinatra::Partials

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))  
require "citygrid_api"
CityGrid.publisher = "citygrid"
CityGrid.load_config File.join(File.dirname(__FILE__), 'citygrid_api.yml.sample'), "qa"

def run_with_rescue
  # don't do anything here, we'll catch
  yield
end

module Riot
  class Context
    def run(reporter)
      reporter.describe_context(self)
      local_run(reporter, situation_class.new)
      run_sub_contexts(reporter)
      reporter
    end
  end
end

# hack to trap all HTTParty::Requests so we can inspect them
class RequestTrap
  def self.trap
    @@trap ||= []
  end
end

module HTTParty
  class Request
    alias_method :old_perform, :perform
    
    def perform
      RequestTrap.trap << self
      old_perform
    end
  end
end

class TestResult
  attr_accessor :desc, :results
  
  def initialize desc
    self.desc = desc
    @results = []
  end
end

# render stylesheets
get '/stylesheets/:name.css' do
 content_type 'text/css', :charset => 'utf-8'
 scss :"stylesheets/#{params[:name]}"
end

get '/' do
  # we want to run tests ourselves
  Riot.alone!
  
  ret = ""
  
  # test_paths = Dir.glob "test/**/test_*.rb"  
  test_paths = Dir.glob "test/api/ad_center/test_*.rb"  
  # test_paths = ["test/api/ad_center/test_account.rb"]
  
  @results = []
  test_paths.each do |path|
    eval(IO.read(path), binding, path)
    # root_contexts << [path, Riot.root_contexts.clone]
    
    result = TestResult.new path.gsub(/^test\//, "").gsub(/\.rb$/, "").split("/").map{|x| x.gsub("_", " ")}.join(" > ")
    Riot.root_contexts.each do |context|
      out = StringIO.new
      reporter = StoredReporter.new out
      begin
        # $stdout = out
        context.run reporter
      rescue CityGrid::API::InvalidResponseFormat => ex
        puts "CAUGHT AN ERROR!"
        x = {"description" => ex.description, "server_msg" => ex.server_msg}
        reporter.fail ex.description, ex.server_msg, "", ""
      rescue => ex
        puts "CAUGHT AN ERROR!"
        reporter.fail ex.to_s, "", "", ""
      ensure 
        # $stdout = STDOUT  
      end

      reporter.context_finished
      result.results += reporter.context_results
    end
    
    @results << result
    
    Riot.root_contexts.clear
  end
  
  haml :test
end
