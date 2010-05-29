require 'rack_rsa_encryption'

use Rack::RsaEncryption

run Proc.new { |env| [200, {"Content-Type" => "text/html"}, "Here's your decrypted query string: #{env["QUERY_STRING"]}\n"] }
