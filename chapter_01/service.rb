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
    error 404, "user not found".to_json
  end
end

post '/api/v1/users' do
  user = User.create(JSON.parse(request.body.read))
  if user
    "true"
  else
    error 400, "" # do nothing for now. we'll cover later
  end
end

put '/api/v1/users/:name' do
  user = User.first(:name => params[:name])
  if user
    user.update_attributes(JSON.parse(request.body.read))
    # we don't have any validations right now. we'll cover later
    "true"
  else
    error 404, "user not found".to_json
  end
end