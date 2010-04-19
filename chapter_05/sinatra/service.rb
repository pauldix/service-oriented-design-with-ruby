require 'rubygems'
require 'yajl'
require 'active_record'
require 'action_pack'
require 'will_paginate'
require 'sinatra'
# this line required to enable the pagination
WillPaginate.enable_activerecord

require 'models/vote.rb'

class Service < Sinatra::Base  
  configure do
    env = ENV["SINATRA_ENV"] || "development"
    databases = YAML.load_file("config/database.yml")
    ActiveRecord::Base.establish_connection(databases[env])
  end
    
  before do
    content_type :json
  end
  
  # create or update a vote
  put '/api/v1/ratings/entries/:entry_id/users/:user_id/vote' do
    begin
      value = Yajl::Parser.parse(request.body.read)

      vote = Vote.create_or_update(
        :user_id => params["user_id"], 
        :entry_id => params["entry_id"], 
        :value => value)
      
      if vote.valid?
        return vote.to_json
      else
        error 400, vote.errors.to_json
      end
    rescue => e
      # log it and return an error
      error 500, e.message.to_json
    end
  end

  # return the entry ids the user voted up on
  get '/api/v1/ratings/users/:user_id/up' do
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
    
    if page > 1
      data[:previous_page] = 
        "/api/v1/ratings/users/#{user_id}/up?page=" +
        "#{page - 1}&per_page=#{per_page}"
    end

    if (page*per_page) < count
      data[:next_page] = 
        "/api/v1/ratings/users/#{user_id}/up?page=" + 
        "#{page + 1}&per_page=#{per_page}"
    end

    data.to_json
  end
  
  # return the entry ids the user voted down on
  get '/api/v1/ratings/users/:user_id/down' do
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
    
    if page > 1
      data[:previous_page] = 
        "/api/v1/ratings/users/#{user_id}/down?page=" +
        "#{page - 1}&per_page=#{per_page}"
    end

    if (page*per_page) < count
      data[:next_page] = 
        "/api/v1/ratings/users/#{user_id}/down?page=" +
        "#{page + 1}&per_page=#{per_page}"
    end

    data.to_json
  end

  # return the vote totals for a specific list of entries
  get '/api/v1/ratings/entries/totals' do
    entry_ids = params["ids"].split(",")

    data = entry_ids.inject({}) do |result, entry_id|
      result.merge!(entry_id => {
        :up   => Vote.up.entry_id(entry_id).count,
        :down => Vote.down.entry_id(entry_id).count
      })
    end
    
    data.to_json
  end
  
  # return the users' vote for a specific list of entries
  get '/api/v1/ratings/users/:user_id/votes' do
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
    
    data.to_json
  end
  
  # return the total number of up and down votes for user
  get '/api/v1/ratings/users/:user_id/totals' do
    user_id = params["user_id"]
    
    data = {
      :up   => Vote.up.user_id(user_id).count,
      :down => Vote.down.user_id(user_id).count
    }
    
    data.to_json
  end
end