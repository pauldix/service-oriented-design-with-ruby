require 'rubygems'
require 'cgi'
require 'hmac_signature'

verb = "GET"
host = "localhost"
path = "/"
query_params = {"user" => "mat", "tag" => "ruby"}

sig = HmacSignature.new('our-secret-key').sign(verb, host, path, query_params)

query_string_without_sig = query_params.map {|k,v| [CGI.escape(k), CGI.escape(v)].join("=") }.join("&")
query_params["sig"] = sig
query_string_with_sig = query_params.map {|k,v| [CGI.escape(k), CGI.escape(v)].join("=") }.join("&")

puts "Without Signature:"
system %Q|curl -i "http://localhost:9292/?#{query_string_without_sig}"|
sleep 2
puts "\n\nWith Signature:"
system %Q|curl -i "http://localhost:9292/?#{query_string_with_sig}"|
