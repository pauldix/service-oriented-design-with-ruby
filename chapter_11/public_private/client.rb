require 'generate_keys'
require 'cgi'
require 'openssl'
require 'base64'

GenerateKeys.generate

verb = "GET"
host = "localhost"
path = "/"
query_params = {"user" => "topper", "tag" => "ruby"}

sorted_query_params = query_params.sort.map{|param| param.join("=")}
# => ["user=mat", "tag=ruby"]
canonicalized_params = sorted_query_params.join("&") # => "user=mat&tag=ruby"
string_to_sign = verb + host + path + canonicalized_params

private_key = OpenSSL::PKey::RSA.new(File.read("example_key.pem"))
sig = CGI.escape(Base64.encode64(private_key.private_encrypt(string_to_sign)))
puts sig

query_string = query_params.map {|k,v| [CGI.escape(k), CGI.escape(v)].join("=") }.join("&")

puts "Without Signature:"
system %Q|curl -i "http://localhost:9292/?#{query_string}"|
sleep 2
puts "\n\nWith Signature:"
system %Q|curl -i -H "X-Auth-Sig: #{sig}" "http://localhost:9292/?#{query_string}"|

