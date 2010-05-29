require 'rsa_sig_validator'

use Rack::RsaSigValidator

run Proc.new { |env| [200, {"Content-Type" => "text/html"}, "Hello World! From Rsa Signature\n"] }
