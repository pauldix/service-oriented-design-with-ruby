require 'hmac_signature'
require 'cgi'

module Rack
  class SignatureValidator
    def initialize(app, secret)
      @app = app
      @secret = secret
      @signer = HmacSignature.new('our-secret-key')
    end
    
    def call(env)
      if signature_is_valid?(env)
        @app.call(env)
      else
        [401, {"Content-Type" => "text/html"}, "Bad Signature"]
      end
    end

    def signature_is_valid?(env)
      verb = env["REQUEST_METHOD"]
      host = env["REMOTE_HOST"]
      path = env["REQUEST_PATH"]
      sig  = env["HTTP_X_AUTH_SIG"]
      query_string = env["QUERY_STRING"]
      query_params = Hash[*query_string.split("&").map { |p| p.split("=") }.flatten.map { |p| CGI.unescape(p) }]
      sig == @signer.sign(verb, host, path, query_params)
    end
  end
end
