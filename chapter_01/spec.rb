require 'rubygems'
require 'spec'
require 'spec/interop/test'
require 'sinatra/test'
require 'client'
require 'service'

set :environment, :test
Test::Unit::TestCase.send :include, Sinatra::Test

DataMapper.setup(:default, {:adapter => "sqlite3", :database => "test.db.sqlite3"})
DataMapper.auto_migrate!

describe "service" do
  it "should get a user"
  it "should create a user"
  it "should update a user"
  it "should delete a user"
  it "should verify login credentials"
end

describe "client" do
  it "should get a user"
  it "should create a user"
  it "should update a user"
  it "should delete a user"
  it "should verify login credentials"
end