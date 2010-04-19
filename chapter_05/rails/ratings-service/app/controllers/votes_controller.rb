class VotesController < ApplicationController
  # create a new vote
  # POST /api/v1/ratings/entries/:entry_id/users/:user_id/vote
  def create
    begin
      value = Yajl::Parser.parse(request.body.read)

      vote = Vote.create_or_update(
        :user_id => params["user_id"], 
        :entry_id => params["entry_id"], 
        :value => value)
      
      if vote.valid?
        render :json => vote.to_json
      else
        render :json => vote.errors.to_json, :status => 400
      end
    rescue => e
      # log it and return an error
      render :json => e.message.to_json, :status => 500
    end
  end

  # GET /api/v1/ratings/users/:user_id/up
  def entry_ids_voted_up_for_user
    page      = (params[:page] || 1).to_i
    per_page  = (params[:per_page] || 25).to_i
    user_id   = params[:user_id]
    count     = Vote.up.user_id(user_id).count
    entry_ids = Vote.voted_up_for_user_id(user_id, page, 
      per_page)
    
    data = {
      :total     => count,
      :entries   => entry_ids  
    }
    
    data[:previous_page] = url_for(:controller => "votes", 
      :action => "entry_ids_voted_up_for_user", 
      :user_id => user_id, 
      :page => page - 1, 
      :per_page => per_page) if page > 1
      
    data[:next_page] = url_for(:controller => "votes", 
      :action => "entry_ids_voted_up_for_user", 
      :user_id => user_id, 
      :page => page + 1, 
      :per_page => per_page) if (page*per_page) < count

    render :json => data.to_json
  end
  
  # GET /api/v1/ratings/users/:user_id/down
  def entry_ids_voted_down_for_user
    page      = (params[:page] || 1).to_i
    per_page  = (params[:per_page] || 25).to_i
    user_id   = params[:user_id]
    count     = Vote.down.user_id(user_id).count
    entry_ids = Vote.voted_down_for_user_id(user_id, page, 
      per_page)
    
    data = {
      :total     => count,
      :entries   => entry_ids  
    }
    
    data[:previous_page] = url_for(:controller => "votes", 
      :action => "entry_ids_voted_down_for_user", 
      :user_id => user_id, 
      :page => page - 1, 
      :per_page => per_page) if page > 1
      
    data[:next_page] = url_for(:controller => "votes", 
      :action => "entry_ids_voted_down_for_user", 
      :user_id => user_id, 
      :page => page + 1, 
      :per_page => per_page) if (page*per_page) < count

    render :json => data.to_json
  end
  
  # GET /api/v1/ratings/entries/totals?ids=1,2
  def totals_for_entries
    entry_ids = params["ids"].split(",")

    data = entry_ids.inject({}) do |result, entry_id|
      result.merge!(entry_id => {
        :up   => Vote.up.entry_id(entry_id).count,
        :down => Vote.down.entry_id(entry_id).count
      })
    end
    
    render :json => data.to_json
  end
  
  # GET /api/v1/ratings/users/:user_id/votes
  def votes_for_users
    user_id   = params["user_id"]
    entry_ids = params["ids"].split(",")
    
    data = entry_ids.inject({}) do |result, entry_id|
      vote = Vote.find_by_user_id_and_entry_id(user_id, 
        entry_id)
      if vote
        result.merge!(entry_id => vote.value)
      else
        result
      end
    end
    
    render :json => data.to_json
  end
  
  # GET /api/v1/ratings/users/:user_id/totals
  def totals_for_user
    user_id = params["user_id"]
    
    data = {
      :up   => Vote.up.user_id(user_id).count,
      :down => Vote.down.user_id(user_id).count
    }
    
    render :json => data.to_json
  end
end
