require File.dirname(__FILE__) + '/../client'

describe "client" do
  it "should get a user" do
    user = User.find(:name => "paul")
    user["name"].should  == "paul"
    user["email"].should == "paul@pauldix.net"
    user["bio"].should   == "rubyist"
  end
  
  it "should create a user" do
    user = User.create({:name => "trotter", :email => "no spam", :password => "whatev"})
    user["name"].should  == "trotter"
    user["email"].should == "no spam"
  end
  
  it "should update a user" do
    user = User.update("paul", {:bio => "rubyist and author"})
    user["name"].should == "paul"
    user["bio"].should  == "rubyist and author"
  end
  
  it "should destroy a user" do
    User.destroy(:name => "bryan").should == true
  end
  
  it "should verify login credentials" do
    user = User.login("paul", "strongpass")
    user["name"].should == "paul"
  end
end