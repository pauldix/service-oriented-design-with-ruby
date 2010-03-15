require File.dirname(__FILE__) + "/../spec_helper.rb"

describe "rating" do
  it "is valid" do
    PauldixRatings::Rating.new(:user_id => "paul", :entry_id => "entry1", :vote => "up").should be_valid
  end
  
  it "requires user_id" do
    rating = PauldixRatings::Rating.new(:entry_id => "entry1", :vote => "up")
    rating.should_not be_valid
    rating.errors.should have_key(:user_id)
  end
  
  it "requires vote to be either up or down" do
    rating = PauldixRatings::Rating.new(:entry_id => "entry1", :user_id => "paul", :vote => "foo")
    rating.should_not be_valid
    rating.errors.should have_key(:vote)
  end
end
