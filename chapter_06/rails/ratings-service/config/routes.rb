ActionController::Routing::Routes.draw do |map|
  map.connect 'api/v1/ratings/entries/:entry_id/users/:user_id/vote',
    :controller => "votes", :action => "create", :method => :put
  map.connect 'api/v1/ratings/users/:user_id/up', 
    :controller => "votes", 
    :action => "entry_ids_voted_up_for_user"
  map.connect 'api/v1/ratings/users/:user_id/down', 
    :controller => "votes", 
    :action => "entry_ids_voted_down_for_user"
  map.connect 'api/v1/ratings/entries/totals', 
    :controller => "votes", :action => "totals_for_entries"
  map.connect 'api/v1/ratings/users/:user_id/votes', 
    :controller => "votes", :action => "votes_for_users"
  map.connect 'api/v1/ratings/users/:user_id/totals', 
    :controller => "votes", :action => "totals_for_user"
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
