require 'rubygems'
require 'sinatra'
require "ap"
require "riot"

IN_DASHBOARD = true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'test'))
require "citygrid_api"
require "publisher_helper"

CityGrid.load_config File.join(File.dirname(__FILE__), 'citygrid_api.yml'), "qa"

# Hack to allow storing tokens between tests
class AuthToken
  @@token = nil

  class << self
    def token
      @@token || generate
    end

    def token= auth_token
      @@token = auth_token
    end

    def generate
      @@token ||= CityGrid.login(
        :username => 'kunimom',
        :password => 'pppppp'
      ).authToken
    end
  end
end

class StoredReporter < Riot::SilentReporter
  def passed; @passed; end
  def failed; @failed; end
  def curls; @curls; end
  
  def curls= v 
    @curls = v
  end
  
  def initialize
    @passed = []
    @failed = []
    @curls = []
    
    super
  end
  
  def pass *args
    @passed << args
    puts "got pass: #{args.join(',')}"
  end
  
  def fail *args
    @failed << args
    puts "got fail: #{args.join(',')}"
  end
end


def run_with_rescue
  begin
    yield
  rescue CityGrid::API::InvalidResponseFormat => ex
    x = {"description" => ex.description, "server_msg" => ex.server_msg}
    puts "======= ERROR ======="
    ap x
    false
  rescue => ex
    ap ex
    false # return false
  end
end

require 'stringio'
 
module Kernel
 
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
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
  
  test_paths = Dir.glob "test/**/test_*.rb"  
  # test_paths = ["test/api/ad_center/test_account.rb", "test/api/ad_center/test_ad_group_geo.rb", "test/test_config.rb"]
  ap test_paths
  root_contexts = []
  
  Riot.root_contexts.clear
  test_paths.each do |path|
    eval(IO.read(path), binding, path)
    root_contexts << [path, Riot.root_contexts.clone]
    Riot.root_contexts.clear
  end
  
  ap Riot.root_contexts
  ap root_contexts
  
  @results = []
  root_contexts.each do |path, contexts|
    puts "running #{path}"
    contexts.each do |context|
      reporter = StoredReporter.new
      cap = capture_stdout do
        context.run reporter
      end
    
      reporter.curls = cap.string.split(/\n/).select{|x| x.index("curl") == 0}
        
      @results << {
        :desc => context.description,
        :reporter => reporter,
        :passed => reporter.passed,
        :failed => reporter.failed,
        :curls => reporter.curls
      }
    end
  end

  haml :test
end
