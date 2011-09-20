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

# Hack to allow storing tokens between tests
class AuthToken
  @@token = nil

  class << self
    def token
      @@token
    end

    def token= auth_token
      @@token = auth_token
    end

    def generate
      @@token || token = CityGrid.login(
        :username => 'QASalesCoord',
        :password => 'pppppp'
      ).authToken
    end
  end
end

# load default config
CityGrid.load_config File.join(File.dirname(__FILE__), '..', 'citygrid_api.yml'), "qa"

# Run code with rescue so that exceptions
# will be printed, but won't stop test suite
def run_with_rescue
  begin
    yield
  rescue => ex
    puts "failed with: #{ex}"
    puts ex.message
    puts ex.backtrace
    false # return false
  end
end