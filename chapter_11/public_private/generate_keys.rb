require 'rubygems'
require 'openssl'

module GenerateKeys
  def self.generate
    if File.exist?("example_key.pem") || File.exist?("example_key.pub")
      puts "Keys exist, not generating"
      return
    end

    rsa_private_key = OpenSSL::PKey::RSA.generate(2048)

    File.open("example_key.pem", "w") do |f|
      f.write rsa_private_key.to_s
    end

    File.open("example_key.pub", "w") do |f|
      f.write rsa_private_key.public_key
    end
  end
end

if $0 == __FILE__
  GenerateKeys.generate
end
