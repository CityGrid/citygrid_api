require File.join(File.dirname(__FILE__), "auth_token")
require File.join(File.dirname(__FILE__), "session_helper")

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
  require "riot"

  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require "citygrid_api"
  require "publisher_helper"

  # load default config
  CityGrid.load_config File.expand_path(File.join(File.dirname(__FILE__), '..', 'citygrid_api.yml'))

  # CityGrid.load_config File.expand_path(File.join(File.dirname(__FILE__), '..', 'citygrid_api.yml.sandbox'))

  # Run code with rescue so that exceptions
  # will be printed, but won't stop test suite
  def run_with_rescue
    begin
      yield
    # TODO: fix?
    #rescue CityGrid::API::InvalidResponseFormat => ex
    rescue StandardError => ex
      x = {"description" => ex.message, "server_msg" => "blank"}
      #x = {"description" => ex.description, "server_msg" => ex.server_msg}
      puts "======= ERROR ======="
      pp x
      pp ex.backtrace
      false
    rescue => ex
      pp ex
      puts ex.backtrace.join("\n")
      false # return false
    end
  end

  # patch in VCR
  require 'vcr'

  VCR.config do |c|
    c.cassette_library_dir = 'fixtures/vcr_cassettes'
    c.stub_with :webmock
    c.allow_http_connections_when_no_cassette = true
  end

  # contexts now use VCR, with a cassette named by the description
  module Riot
    class Context
      alias_method :old_run, :run
      def run reporter
        # TODO: does it make any sense for API gem to use vcr?
        #if option(:vcr) != nil && option(:vcr) == false
         old_run reporter
        # else
        #  VCR.use_cassette self.detailed_description[0..70] do
        #    old_run reporter
        #  end
        # end
      end

    end
  end

end
