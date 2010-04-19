VoteService::Application.routes.draw do |map|
  scope "/api/ratings" do
    constraints(:accept => 
      "application/vnd.pauldix.voteservice-v1+json") do
        
      controller :votes do
        put "/entries/:entry_id/users/:user_id/vote",
          :to => "create"
        
        get "/users/:user_id/up",
          :to => "entry_ids_voted_up_for_user"
        
        get "/users/:user_id/down",
          :to => "entry_ids_voted_down_for_user"
        
        get "/entries/totals",
          :to => "totals_for_entries"
        
        get "/users/:user_id/votes",
          :to => "votes_for_users"
        
        get "/users/:user_id/totals",
          :to => "totals_for_user"
      end
    end
  end
end
