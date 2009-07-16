require 'rubygems'
require 'typhoeus'
require 'json'

class User
  include Typhoeus
  remote_defaults :base_uri => "http://localhost:3000"
  define_remote_method :find, 
    :path => "/api/v1/users/:name",
    :on_success => lambda {|response| JSON.parse(response.body)},
    :on_failure => lambda {|response| 
      if response.code == 404
        nil
      else
        raise response.body
      end}
  define_remote_method :create_remote,
    :method => :post,
    :path => "/api/v1/users",
    :on_success => lambda {|response| JSON.parse(response.body)}
  define_remote_method :update_remote,
    :method => :put,
    :path => "/api/v1/users/:name",
    :on_success => lambda {|response| JSON.parse(response.body)}
  define_remote_method :destroy,
    :method => :delete,
    :path => "/api/v1/users/:name",
    :on_success => lambda {|response| true}
  define_remote_method :verify,
    :method => :post,
    :path => "/api/v1/users/:name/sessions",
    :on_success => lambda {|response| JSON.parse(response.body)},
    :on_failure => lambda {|response|
      if response.code == 400
        nil
      else
        raise response.body
      end}
                       
  def self.create(attributes = {})
    create_remote(:body => attributes.to_json)
  end
  
  def self.update(name, attrs)
    update_remote(:name => name, :body => attrs.to_json)
  end
  
  def self.login(username, password)
    verify(:name => username, 
           :body => {:password => password}.to_json)
  end
end