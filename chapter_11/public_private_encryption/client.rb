require 'generate_keys'
require 'cgi'
require 'openssl'
require 'base64'

GenerateKeys.generate

verb = "GET"
host = "localhost"
path = "/"
query_params = {"user" => "topper", "tag" => "ruby"}

private_key = OpenSSL::PKey::RSA.new(File.read("example_key.pem"))

query_string = query_params.map {|k,v| [CGI.escape(k), CGI.escape(v)].join("=") }.join("&")
encrypted_query_string = CGI.escape(Base64.encode64(private_key.private_encrypt(query_string)))

puts "Encrypted"
encrypted = `curl "http://localhost:9292/?q=#{encrypted_query_string}" 2>/dev/null`
puts private_key.private_decrypt(encrypted)
puts

