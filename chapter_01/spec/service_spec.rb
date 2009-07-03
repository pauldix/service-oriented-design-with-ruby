require File.dirname(__FILE__) + '/spec_helper'

describe "service" do
  describe "GET on /v1/users/:id" do
    it "should return a user by id"
    it "should return a user with a name"
    it "should return a user with an email"
    it "should return a user with a password"
    it "should return a user with a bio"
    it "should return a 404 for a user that doesn't exist"
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
