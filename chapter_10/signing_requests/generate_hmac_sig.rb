require 'rubygems'
require 'cgi'
require 'hmac_signature'

verb = "GET"
host = "localhost"
path = "/"
query_params = {"user" => "mat", "tag" => "ruby"}

unescaped_sig = HmacSignature.new('our-secret-key').sign(verb, host, path, query_params)
sig = CGI.escape(unescaped_sig)

query_string = query_params.map {|k,v| [CGI.escape(k), CGI.escape(v)].join("=") }.join("&")

puts "Without Signature:"
system %Q|curl -i "http://localhost:9292/?#{query_string}"|
sleep 2
puts "\n\nWith Signature:"
system %Q|curl -i -H "X-Auth-Sig: #{sig}" "http://localhost:9292/?#{query_string}"|
