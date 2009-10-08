require 'rubygems'
require 'typhoeus'
require 'json'

hydra = Typhoeus::Hydra.new
ratings  = {}
entries  = {}
entry_id = []

entry_list_request = Typhoues::Request.new(
  "http://localhost:3000/api/v1/reading_lists/paul")

entry_list_request.on_complete do |response|
  entry_ids = JSON.parse(response.body)["entries"]
  
  ratings_request = Typhoeus::Request.new(
    "http://localhost:3000/api/v1/ratings/entries",
    :params => {:ids => entry_ids.join(",")})
    
  ratings_request.on_complete do |response|
    ratings = JSON.parse(response.body)
  end  
  hydra.queue(ratings_request)

  entry_request
  entry_request = Typhoeus::Request.new(
    "http://localhost:3000/api/v1/entries",
    :params => {:ids => entry_ids.join(",")})

  entry_request.on_complete do |response|
    entries = JSON.parse(response.body)
  end
  hydra.queue(request)
end

hydra.queue(entry_list_request)
hydra.run
