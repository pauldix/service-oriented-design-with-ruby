require 'hmac_sig_validator'

use Rack::SignatureValidator, 'ourSekret'

run Proc.new { |env| [200, {"Content-Type" => "text/html"}, "Hello World! From Signature\n"] }
