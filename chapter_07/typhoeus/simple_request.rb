require 'rubygems'
require 'typhoeus'

hydra = Typhoeus::Hydra.new
request = Typhoeus::Request.new("http://localhost:3000",
  :timeout => 100)
request.on_complete do |response|
  puts response.code
  puts response.body
end
hydra.queue(request)
hydra.run
