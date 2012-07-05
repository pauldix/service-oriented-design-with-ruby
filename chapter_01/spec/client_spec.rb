#require File.dirname(__FILE__) + '/../client'
require_relative '../client.rb'

# NOTE: to run these specs you must have the service running locally. Do like this:
# ruby service.rb -p 3000 -e test

# Also note that after a single run of the tests the server must be restarted to reset
# the database. We could change this by deleting all users in the test setup.
describe "client" do
  before(:all) do
    User.base_uri = "http://localhost:3000"

    User.destroy("paul")
    User.destroy("trotter")

    User.create(
      :name => "paul",
      :email => "paul@pauldix.net",
      :password => "strongpass",
      :bio => "rubyist")
    User.create(
      :name => "bryan",
      :email => "bryan@spamtown.usa",
      :password => "strongpass",
      :bio => "rubyist")
  end

  it "should get a user" do
    user = User.find_by_name("paul")
    user["name"].should  == "paul"
    user["email"].should == "paul@pauldix.net"
    user["bio"].should   == "rubyist"
  end

  it "should return nil for a user not found" do
    User.find_by_name("gosling").should be_nil
  end

  it "should create a user" do
    random_name = ('a'..'z').to_a.shuffle[0,8].join
    random_email = ('a'..'z').to_a.shuffle[0,8].join
    user = User.create(
      :name => random_name,
      :email => random_email,
      :password => 'whatev')
    user['name'].should == random_name
    user['email'].should == random_email
    User.find_by_name(random_name).should == user
  end

  it "should update a user" do
    user = User.update("paul", :bio => "rubyist and author")
    user["name"].should == "paul"
    user["bio"].should  == "rubyist and author"
    User.find_by_name('paul').should == user
  end

  it "should destroy a user" do
    User.destroy("bryan").should == true
    User.find_by_name("bryan").should be_nil
  end

  it "should verify login credentials" do
    user = User.login("paul", "strongpass")
    user["name"].should == "paul"
  end

  it "should return nil with invalid credentials" do
    User.login("paul", "wrongpassword").should be_nil
  end
end