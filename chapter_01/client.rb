require 'rubygems'
require 'typhoeus'
require 'json'

class User
  include Typhoeus
  class << self; attr_accessor :base_uri end
  
  def self.find_by_name(name)
    get("#{base_uri}/api/v1/users/#{name}", 
      :on_success => lambda {|res| JSON.parse(res.body)},
      :on_failure => lambda {|response| 
        if response.code == 404
          nil
        else
          raise response.body
        end})
  end
    
  def self.create(attributes = {})
    post("#{base_uri}/api/v1/users",
      :body       => attributes.to_json,
      :on_success => lambda {|res| JSON.parse(res.body)})
  end
  
  def self.update(name, attributes)
    put("#{base_uri}/api/v1/users/#{name}",
      :body       => attributes.to_json,
      :on_success => lambda {|res| JSON.parse(res.body)})
  end
  
  def self.destroy(name)
    delete("#{base_uri}/api/v1/users/#{name}",
      :on_success => lambda {|response| true})
  end
  
  def self.login(name, password)
    post("#{base_uri}/api/v1/users/#{name}/sessions",
      :body       => {:password => password}.to_json,
      :on_success => lambda {|res| JSON.parse(res.body)},
      :on_failure => lambda {|response|
        if response.code == 400
          nil
        else
          raise response.body
        end})
  end
end