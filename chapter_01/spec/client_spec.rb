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
    expect(user["name"]).to eq "paul"
    expect(user["email"]).to eq "paul@pauldix.net"
    expect(user["bio"]).to eq "rubyist"
  end

  it "should return nil for a user not found" do
    expect(User.find_by_name("gosling")).to eq nil
  end

  it "should create a user" do
    random_name = ('a'..'z').to_a.shuffle[0,8].join
    random_email = ('a'..'z').to_a.shuffle[0,8].join
    user = User.create(
      :name => random_name,
      :email => random_email,
      :password => 'whatev')
    expect(user["name"]).to eq random_name
    expect(user["email"]).to eq random_email
    expect(User.find_by_name(random_name)).to eq user
  end

  it "should update a user" do
    user = User.update("paul", :bio => "rubyist and author")
    expect(user["name"]).to eq "paul"
    expect(user["bio"]).to eq "rubyist and author"
    expect(User.find_by_name('paul')).to eq user
  end

  it "should destroy a user" do
    expect(User.destroy("bryan")).to eq true
    expect(User.find_by_name("bryan")).to eq nil
  end

  it "should verify login credentials" do
    user = User.login("paul", "strongpass")
    expect(user["name"]).to eq "paul"
  end

  it "should return nil with invalid credentials" do
    expect(User.login("paul", "wrongpassword")).to eq nil
  end
end