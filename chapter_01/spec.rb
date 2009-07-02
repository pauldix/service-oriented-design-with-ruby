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
  describe "GET on /v1/users/:id" do
    it "should return a user by id"
    it "should return a user with a name"
    it "should return a user with an email"
    it "should return a user with a password"
    it "should return a user with a bio"
  end
  
  describe "POST on /v1/users" do
    it "should create a user"    
  end
  
  describe "PUT on /v1/users/:id" do
    it "should update a user"    
  end
  
  describe "DELETE on /v1/users/:id" do
    it "should delete a user"    
  end
  
  describe "POST on /v1/users/:id/sessions" do
    it "should verify login credentials"
    it "should return the full user object"
  end
end

describe "client" do
  it "should get a user"
  it "should create a user"
  it "should update a user"
  it "should delete a user"
  it "should verify login credentials"
end