require File.dirname(__FILE__) + '/../service'
require 'spec'
require 'spec/interop/test'
require 'rack/test'

set :environment, :test
Test::Unit::TestCase.send :include, Rack::Test::Methods

def app
  Sinatra::Application
end

DataMapper.setup(:default, 
  {:adapter => "sqlite3", :database => "test.db.sqlite3"})
DataMapper.auto_migrate!

describe "service" do
  describe "GET on /api/v1/users/:id" do    
    before(:all) do
      User.create(
        :name => "paul", 
        :email => "paul@pauldix.net", 
        :password => "strongpass", 
        :bio => "rubyist")
    end

    it "should return a user by name" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["name"].should == "paul"
    end
    
    it "should return a user with an email" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["email"].should == "paul@pauldix.net"
    end
    
    it "should not return a user's password" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes.should_not have_key("password")
    end
    
    it "should return a user with a bio" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["bio"].should == "rubyist"      
    end
    
    it "should return a 404 for a user that doesn't exist" do
      get '/api/v1/users/foo'
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/v1/users" do
    it "should create a user" do
      post '/api/v1/users', {
          :name     => "trotter", 
          :email    => "no spam", 
          :password => "whatever", 
          :bio      => "southern bell"}.to_json
      last_response.should be_ok
      get '/api/v1/users/trotter'
      attributes = JSON.parse(last_response.body)
      attributes["name"].should  == "trotter"
      attributes["email"].should == "no spam"
      attributes["bio"].should   == "southern bell"
    end
  end
  
  describe "PUT on /api/v1/users/:id" do
    it "should update a user" do
      User.create(
        :name => "bryan", 
        :email => "no spam", 
        :password => "whatever", 
        :bio => "rspec master")
      put '/api/v1/users/bryan', {
        :bio => "testing freak"}.to_json
      last_response.should be_ok
      get '/api/v1/users/bryan'
      attributes = JSON.parse(last_response.body)
      attributes["bio"].should == "testing freak"
    end
  end
  
  describe "DELETE on /api/v1/users/:id" do
    it "should delete a user" do
      User.create(
        :name     => "francis", 
        :email    => "no spam", 
        :password => "whatever", 
        :bio      => "williamsburg hipster")
      delete '/api/v1/users/francis'
      last_response.should be_ok
      get '/api/v1/users/francis'
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/v1/users/:id/sessions" do
    before(:all) do
      User.create(:name => "josh", :password => "nyc.rb rules")
    end
    
    it "should return the user object on valid credentials" do
      post '/api/v1/users/josh/sessions', {
        :password => "nyc.rb rules"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["name"].should == "josh"
    end

    it "should fail on invalid credentials" do
      post '/api/v1/users/josh/sessions', '"wrong"'
      last_response.status.should == 400
    end    
  end
end
