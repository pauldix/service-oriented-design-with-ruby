require 'cgi'
require 'openssl'
require 'base64'

module Rack
  class RsaEncryption
    def initialize(app)
      @app = app
      @key = OpenSSL::PKey::RSA.new(IO.read("example_key.pub"))
    end

    def call(env)
      env["QUERY_STRING"] = decrypt_query_string(env)
      resp = @app.call(env)
      resp[-1] = @key.public_encrypt(resp[-1])
      resp
    end

    def decrypt_query_string(env)
      req = Rack::Request.new(env)
      # Do lookup for user's key here if desired
      encrypted = req.params.delete("q")
      decrypted = @key.public_decrypt(Base64.decode64(encrypted))
      as_query_hash = Hash[*decrypted.split("&").map { |p| p.split("=") }.flatten.map { |p| CGI.unescape(p) }]
      pairs = req.params.merge(as_query_hash).map { |k, v| [k,v].join("=") }
      pairs.join("&")
    end
  end
end
