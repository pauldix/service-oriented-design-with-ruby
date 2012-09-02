require 'typhoeus'
require 'json'

class User
  class << self; attr_accessor :base_uri end

  def self.find_by_name(name)
    response = Typhoeus::Request.get("#{base_uri}/api/v1/users/#{name}")
    if response.code == 200
      JSON.parse(response.body)["user"]
    elsif response.code == 404
      nil
    else
      raise response.body
    end
  end

  def self.create attributes
    response = Typhoeus::Request.post("#{base_uri}/api/v1/users", :body => attributes.to_json )
    if response.code == 200
      JSON.parse(response.body)['user']
    elsif response.code == 400
      nil
    else
      raise response.body
    end
  end

  def self.update(name, attributes)
    response = Typhoeus::Request.put("#{base_uri}/api/v1/users/#{name}", :body => attributes.to_json)
    if response.code == 200
      JSON.parse(response.body)['user']
    elsif response.code == 400 || response.code == 404
      nil
    else
      raise response.body
    end
  end

  def self.destroy(name)
    response = Typhoeus::Request.delete("#{base_uri}/api/v1/users/#{name}")
    response.success? # response.code == 200
  end

  def self.login(name, password)
    response = Typhoeus::Request.post("#{base_uri}/api/v1/users/#{name}/sessions", :body => {:password => password}.to_json)
    if response.success? # response.code == 200
      JSON.parse(response.body)["user"]
    elsif response.code == 400
      nil
    else
      raise response.body
    end
  end
end