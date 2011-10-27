require 'rubygems'
require 'sinatra'
require "awesome_print"
require "riot"
require "haml"

module Sinatra::Partials
  def partial(template, *args)
    template_array = template.to_s.split('/')
    template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << haml(:"#{template}", options.merge(:layout =>
        false, :locals => {template_array[-1].to_sym => member}))
      
      end.join("\n")
    else
      haml(:"#{template}", options)
    end
  end
end

helpers Sinatra::Partials

IN_DASHBOARD = true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))  
require "citygrid_api"
require File.join(File.dirname(__FILE__), "lib", "dashboard", "stored_reporter.rb")

CityGrid.publisher = "citygrid"

CityGrid.load_config File.join(File.dirname(__FILE__), 'citygrid_api.yml.sample'), "qa"

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


def run_with_rescue
  # don't do anything here, we'll catch
  yield
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
  # test_paths = ["test/test_config.rb"]
  root_contexts = []
  
  Riot.root_contexts.clear
  test_paths.each do |path|
    eval(IO.read(path), binding, path)
    root_contexts << [path, Riot.root_contexts.clone]
    Riot.root_contexts.clear
  end
  
  @context_results = []
  root_contexts.each do |path, contexts|
    contexts.each do |context|
      out = StringIO.new
      reporter = StoredReporter.new out
      begin
        $stdout = out
        context.run reporter
      rescue CityGrid::API::InvalidResponseFormat => ex
        puts "CAUGHT AN ERROR!"
        x = {"description" => ex.description, "server_msg" => ex.server_msg}
        reporter.fail ex.description, ex.server_msg, "", ""
      rescue => ex
        puts "CAUGHT AN ERROR!"
        reporter.fail ex.to_s, "", "", ""
      ensure 
        $stdout = STDOUT  
      end
      
      reporter.flush_io
      
      @context_results += reporter.context_results
    end
  end

  haml :test
end
