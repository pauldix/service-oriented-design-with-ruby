require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vote do
  before(:each) do
    @valid_attributes = {
      :entry_id => "value for entry_id",
      :user_id => "value for user_id",
      :value => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Vote.create!(@valid_attributes)
  end
  
  describe "validations" do
    it "requires a vote value of either 1 or -1" do
      Vote.create(@valid_attributes.merge!(:value => 0)).should 
        have(1).error_on(:value)
    end
    
    it "requires the user_id to be unique in entry_id scope" do
      Vote.create!(@valid_attributes)
      Vote.create(@valid_attributes).should 
        have(1).error_on(:user_id)
      Vote.create!(
        @valid_attributes.merge!(:user_id => "whatevs"))
    end
    
    it "requires an entry_id" do
      attributes = @valid_attributes.merge!(:entry_id => nil)
      Vote.create(attributes).should have(1).error_on(:entry_id)
    end
    
    it "requires a user_id" do
      attributes = @valid_attributes.merge!(:user_id => nil)
      Vote.create(attributes).should have(1).error_on(:user_id)
    end
  end
  
  describe "#create_or_update" do
    it "should create a vote for a new entry and user" do
      proc {
        Vote.create_or_update(@valid_attributes)
      }.should change(Vote, :count).by(1)
    end
    
    it "should update for an existing entry and user" do
      Vote.create!(@valid_attributes)
      vote = nil
      proc {
        vote = Vote.create_or_update(
          @valid_attributes.merge!(:value => -1))
      }.should change(Vote, :count).by(0)
      Vote.find_by_entry_id_and_user_id(
        @valid_attributes[:entry_id], 
        @valid_attributes[:user_id]).should == vote
    end
  end
  
  describe "entries by a user" do
    before(:all) do
      Vote.create!(:entry_id => "1", :user_id => "entry_user", :value => 1)
      Vote.create!(:entry_id => "3", :user_id => "entry_user", :value => 1)
      Vote.create!(:entry_id => "2", :user_id => "entry_user", :value => 1)
      Vote.create!(:entry_id => "5", :user_id => "entry_user", :value => -1)
    end
    
    describe "#entries_voted_up_by_user" do
      it "returns the entries voted up by a user in date descending order" do
        Vote.entries_voted_up_by_user("entry_user").should == {
          :total => 3,
          :entry_ids => ["2", "3", "1"]
        }
      end
      
      it "takes pagination options" do
        
      end
    end
    
    it "returns the data structure for the entries voted down by a user"
  end
end
