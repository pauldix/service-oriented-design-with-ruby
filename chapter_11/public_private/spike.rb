require 'rubygems'
require 'openssl'

rsa_private_key = OpenSSL::PKey::RSA.generate(2048)
File.open("example_key", "w") do |f|
  f.write rsa_private_key.to_s
end
File.open("example_key.pub", "w") do |f|
  f.write rsa_private_key.public_key
end

rsa_public_key = OpenSSL::PKey::RSA.new(rsa_private_key.public_key)

encrypted = rsa_private_key.private_encrypt("big boys battle bulls")
puts encrypted
decrypted = rsa_public_key.public_decrypt(encrypted)
puts decrypted
