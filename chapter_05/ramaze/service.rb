require 'rubygems'
require 'yajl'
require 'active_record'
require 'action_pack'
require 'will_paginate'
WillPaginate.enable_activerecord
require 'models/vote.rb'
env = ENV["RAMAZE_ENV"] || "development"
databases = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(databases[env])

require 'ramaze'

class ServiceController < Ramaze::Controller
  map '/api/v1/ratings'
  
  # /api/v1/ratings/entries/*
  def entries(*strings)
    # GET /api/v1/ratings/entries/totals?ids=1,2
    if strings.first == "totals" && request.request_method == "GET"
      entry_ids = request["ids"].split(",")

      data = entry_ids.inject({}) do |result, entry_id|
        result.merge!(entry_id => {
          :up   => Vote.up.entry_id(entry_id).count,
          :down => Vote.down.entry_id(entry_id).count
        })
      end

      data.to_json
    # PUT /api/v1/ratings/entries/:entry_id/users/:user_id/vote
    elsif request.request_method == "PUT" # it should be a vote
      begin
        value   = Yajl::Parser.parse(request.body.read)
        user_id  = strings[2]
        entry_id = strings[0]
    
        vote = Vote.create_or_update(
          :user_id => user_id,
          :entry_id => entry_id,
          :value => value)
    
        if vote.valid?
          response.body = vote.to_json
        else
          response.status = 400
          response.body   = vote.errors.to_json
        end
      rescue => e
        # log it and return an error
        response.status = 500
        response.body   = e.message.to_json
      end
    # NOT FOUND
    else
      response.status = 404
    end
  end
  
  # /api/v1/ratings/users/*
  def users(user_id, operation)
    case operation
    # /api/v1/ratings/users/:user_id/up
    when "up"
      puts request["page"].to_i.inspect
      page      = (request["page"] || 1).to_i
      per_page  = (request["per_page"] || 25).to_i
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
    # /api/v1/ratings/users/:user_id/down
    when "down"
      page      = (request[:page] || 1).to_i
      per_page  = (request[:per_page] || 25).to_i
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
    # /api/v1/ratings/users/:user_id/votes?ids=1,2
    when "votes"
      entry_ids = request["ids"].split(",")

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
    # /api/v1/ratings/users/:user_id/totals
    when "totals"
      data = {
        :up   => Vote.up.user_id(user_id).count,
        :down => Vote.down.user_id(user_id).count
      }

      data.to_json
    end
  end
end
Ramaze.start
