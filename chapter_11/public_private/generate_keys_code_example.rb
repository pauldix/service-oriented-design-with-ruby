require 'rubygems'
require 'openssl'

rsa_private_key = OpenSSL::PKey::RSA.generate(2048)

File.open("example_key.pem", "w") do |f|
  f.write rsa_private_key.to_s
end

File.open("example_key.pub", "w") do |f|
  f.write rsa_private_key.public_key
end
