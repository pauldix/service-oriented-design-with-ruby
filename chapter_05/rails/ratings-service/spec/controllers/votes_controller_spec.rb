require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VotesController do
  describe "submiting a vote" do
    it "has a route to PUT /api/v1/ratings/entries/:entry_id/users/:user_id/vote" do
      route_for(
        :controller => "votes", 
        :action => "create", 
        :entry_id => "45", 
        :user_id => "3").should == {
          :path => "/api/v1/ratings/entries/45/users/3/vote",
          :method => :put}
    end
    
    it "should create a vote" do
      put :create, :entry_id => "45", :user_id => "3", :body => "up".to_json
      Vote.count.should == 1
    end
  end
end
