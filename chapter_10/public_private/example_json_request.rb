require 'generate_keys'
require 'cgi'
require 'openssl'
require 'base64'

GenerateKeys.generate

verb = "POST"
host = "localhost"
path = "/"
body = %|{"name": "Jenn", "lifeGoal": "Be Awesome"}|

string_to_sign = verb + host + path + body

private_key = OpenSSL::PKey::RSA.new(File.read("example_key.pem"))
sig = CGI.escape(Base64.encode64(private_key.private_encrypt(string_to_sign)))
puts sig

puts "Without Signature:"
system %Q|curl -i -X POST -d '#{body}' "http://localhost:9292/"|
sleep 2
puts "\n\nWith Signature:"
system %Q|curl -i -X POST -H "X-Auth-Sig: #{sig}" -d '#{body}' "http://localhost:9292/"|

