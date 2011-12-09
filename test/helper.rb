# Hack to allow storing tokens between tests
class AuthToken
  class << self
    def kunimom
      @@kunimom ||= CityGrid.login(
        :username => 'kunimom',
        :password => 'pppppp'
      ).authToken
    end
    
    def dou
      @@sales_cord ||= CityGrid.login(
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
   
    def rand_number
      @@rand_number ||= rand(10000000)
    end
    
    def generate
      kunimom
    end
  end
end

# don't do gem setup if we're in the dashboad environment
unless defined? IN_DASHBOARD 
  require 'rubygems'
  require 'bundler'
  begin
    Bundler.setup(:default, :development)
  rescue Bundler::BundlerError => e
    $stderr.puts e.message
    $stderr.puts "Run `bundle install` to install missing gems"
    exit e.status_code
  end
  require "ap"
  require "riot"

  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require "citygrid_api"
  require "publisher_helper"

  # load default config
  CityGrid.load_config File.expand_path(File.join(File.dirname(__FILE__), '..', 'citygrid_api.yml.sample')), "qa"

  # Run code with rescue so that exceptions
  # will be printed, but won't stop test suite
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
end