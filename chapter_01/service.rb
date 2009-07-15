require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-serializer'

# our data store
class User
  include DataMapper::Resource
  include DataMapper::Serialize

  property :name,     String, :key => true
  property :email,    String
  property :password, String
  property :bio,      String
end

# setting up our environment
env_arg = ARGV.index("-e")
if env_arg && ARGV[env_arg+1] == "test"
  DataMapper.setup(:default, {:adapter => "sqlite3", :database => "test.db.sqlite3"})
  DataMapper.auto_migrate!
  User.create(:name => "paul", :email => "paul@pauldix.net", :password => "strongpass", :bio => "rubyist")
  User.create(:name => "bryan", :email => "no spam", :password => "strongpass", :bio => "rubyist")
else
  DataMapper.setup(:default, {:adapter => "sqlite3", :database => "db.sqlite3"})
end

# the HTTP entry points to our service

# get a user by name
get '/api/v1/users/:name' do
  user = User.first(params)
  if user
    user.to_json(:exclude => :password)
  else
    error 404, "user not found".to_json
  end
end

# create a new user
post '/api/v1/users' do
  begin
    user = User.create(JSON.parse(request.body.read))
    if user
      user.to_json(:exclude => :password)
    else
      error 400, "" # do nothing for now. we'll cover later
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# update an existing user
put '/api/v1/users/:name' do
  user = User.first(:name => params[:name])
  if user
    begin
      user.update_attributes(JSON.parse(request.body.read))
      # we don't have any validations right now. we'll cover later
      user.to_json(:exclude => :password)
    rescue => e
      error 400, e.message.to_json
    end
  else
    error 404, "user not found".to_json
  end
end

# destroy an existing user
delete '/api/v1/users/:name' do
  user = User.first(params)
  if user
    user.destroy
  else
    error 404, "user not found".to_json
  end
end

# verify a user name and password
post '/api/v1/users/:name/sessions' do
  begin
    attributes = JSON.parse(request.body.read)
    user = User.first(
      :name     => params["name"], 
      :password => attributes["password"])
    if user
      user.to_json(:exclude => :password)
    else
      error 400, "invalid login credentials".to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end