require 'rubygems'
require 'yajl'
require 'active_record'
require 'action_pack'
require 'will_paginate'
WillPaginate.enable_activerecord

require 'models/vote.rb'

module Rack
  class RatingsService
    def initialize(environment)
      dbs = YAML.load_file("config/database.yml")
      ActiveRecord::Base.establish_connection(dbs[environment])
    end
    
    # every request will enter here
    def call(env)
      request = Rack::Request.new(env)
      path = request.path_info
      begin
        # return the vote totals for a specific list of entries
        if path == "/api/v1/ratings/entries/totals"
          ids = ids_from_params(request.params)
          return get_entry_totals(ids)
        # create or update a vote
        elsif path.start_with?("/api/v1/ratings/entries") && 
            path.end_with?("vote") && request.put?
          entry_id, user_id = entry_id_and_user_id_from_path(path)
          value = Yajl::Parser.parse(request.body.read)
          return process_vote(entry_id, user_id, value)
        # it's a request to get information for a user
        elsif path.start_with? "/api/v1/ratings/users"
          # get the users votes on specific entries
          if path.end_with? "votes"
            ids = ids_from_params(request.params)
            return get_user_votes(user_id_from_path(path), ids)
          # get the entry ids a user voted down on
          elsif path.end_with? "down"
            return get_down_votes(user_id_from_path(path),
              request.params)
          # get the entry ids a user voted up on
          elsif path.end_with? "up"
            return get_up_votes(user_id_from_path(path),
              request.params)
          # get the up and down totals for a user
          elsif path.end_with? "totals"
            return get_user_totals(user_id_from_path(path))
          end
        end
      rescue => e
        # log it and return an error
        return [500, { 'Content-Type' => 'application/json' },
          e.message.to_json]
      end    

      [404, { 'Content-Type' => 'application/json' }, 
        "Not Found".to_json]
    end
    
    def process_vote(entry_id, user_id, value)
      vote = Vote.create_or_update(
        :user_id => user_id, 
        :entry_id => entry_id, 
        :value => value)

      if vote.valid?
        [200, { 'Content-Type' => 'application/json' },
          vote.to_json]
      else
        [400, { 'Content-Type' => 'application/json' },
          vote.errors.to_json]
      end
    end
    
    def get_entry_totals(entry_ids)
      data = entry_ids.inject({}) do |result, entry_id|
        result.merge!(entry_id => {
          :up   => Vote.up.entry_id(entry_id).count,
          :down => Vote.down.entry_id(entry_id).count
        })
      end

      [200, {'Content-Type'=>'application/json'}, data.to_json]
    end
    
    def get_up_votes(user_id, params)
      page      = (params[:page] || 1).to_i
      per_page  = (params[:per_page] || 25).to_i
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

      [200, {'Content-Type'=>'application/json'}, data.to_json]
    end
    
    def get_down_votes(user_id, params)
      page      = (params[:page] || 1).to_i
      per_page  = (params[:per_page] || 25).to_i
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

      [200, {'Content-Type'=>'application/json'}, data.to_json]
    end
    
    def get_user_totals(user_id)
      data = {
        :up   => Vote.up.user_id(user_id).count,
        :down => Vote.down.user_id(user_id).count
      }

      [200, {'Content-Type'=>'application/json'}, data.to_json]
    end
    
    def get_user_votes(user_id, entry_ids)
      data = entry_ids.inject({}) do |result, entry_id|
        vote = Vote.find_by_user_id_and_entry_id(user_id,
          entry_id)
        if vote
          result.merge!(entry_id => vote.value)
        else
          result
        end
      end

      [200, {'Content-Type'=>'application/json'}, data.to_json]
    end
    
    def user_id_from_path(path)
      path.match(/.*users\/(.*)\/.*/)[1]
    end
    
    def entry_id_and_user_id_from_path(path)
      matches = path.match(/.*entries\/(.*)\/users\/(.*)\/vote/)
      [matches[1], matches[2]]
    end
    
    def ids_from_params(params)
      params.has_key?("ids") ? params["ids"].split(",") : []
    end
  end
end

environment = ENV["RACK_ENV"] || "development"
service = Rack::RatingsService.new(environment)
run service