require 'rubygems'
require 'hmac'
require 'hmac-sha2'
require 'base64'

class HmacSignature
  def initialize(key)
    @key = key
  end

  def sign(verb, host, path, query_params)
    sorted_query_params = query_params.sort.map{|param| param.join("=")}
    # => ["user=mat", "tag=ruby"]

    canonicalized_params = sorted_query_params.join("&") # => "user=mat&tag=ruby"

    string_to_sign = verb + host + path + canonicalized_params
    hmac = HMAC::SHA256.new(@key)
    hmac.update(string_to_sign)
    Base64.encode64(hmac.digest).chomp
  end
end
