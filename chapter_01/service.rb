require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-serializer'

DataMapper.setup(:default, {:adapter => "sqlite3", :database => "db.sqlite3"})

class User
  include DataMapper::Resource
  include DataMapper::Serialize

  property :name,     String, :key => true
  property :email,    String
  property :password, String
  property :bio,      String
end

get '/api/v1/users/:name' do
  user = User.first(params)
  if user
    user.to_json(:exclude => :password)
  else
    error 404, "user not found"
  end
end

post '/api/v1/users' do
  user = User.create(JSON.parse(request.body.read))
  if user
    "true"
  else
    error 400, user.errros.to_json
  end
end