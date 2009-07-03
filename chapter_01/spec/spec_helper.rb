require File.dirname(__FILE__) + '/../service'
require File.dirname(__FILE__) + '/../client'
require 'spec'
require 'spec/interop/test'
require 'rack/test'

set :environment, :test
Test::Unit::TestCase.send :include, Rack::Test::Methods

def app
  Sinatra::Application
end

DataMapper.setup(:default, {:adapter => "sqlite3", :database => "test.db.sqlite3"})
DataMapper.auto_migrate!
